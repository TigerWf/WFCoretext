//
//  ILSlider.m
//  ILSlider
//
//  Created by 吴福虎 on 14-10-17.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ILSlider.h"

@interface ILSlider ()

@property (nonatomic, strong) UIColor *lineColor;//整条线的颜色
@property (nonatomic, strong) UIColor *slidedLineColor;//滑动过的线的颜色
@property (nonatomic, strong) UIColor *circleColor;//圆的颜色

@property (nonatomic, assign) CGFloat lineWidth;//线的宽度
@property (nonatomic, assign) CGFloat circleRadius;//圆的半径
@property (nonatomic, assign) BOOL    isSliding;//是否正在滑动

@end

@implementation ILSlider

- (id)initWithFrame:(CGRect)frame direction:(ILSliderDirection)direction{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _minValue = 0;
        _maxValue = 1;
         
        _direction = direction;
        _lineColor = [UIColor whiteColor];
        _slidedLineColor = [UIColor redColor];
        _circleColor = [UIColor whiteColor];
        
        _ratioNum = 0.0;//缺省为0
        _lineWidth = 1;
        _circleRadius = 10;
        
        
    }
    return self;

}



- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //画总体的线
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    
    CGFloat startLineX = (_direction == ILSliderDirectionHorizonal ? _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat startLineY = (_direction == ILSliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : _circleRadius);//起点
    
    CGFloat endLineX = (_direction == ILSliderDirectionHorizonal ? self.frame.size.width - _circleRadius : (self.frame.size.width - _lineWidth) / 2);
    CGFloat endLineY = (_direction == ILSliderDirectionHorizonal ? (self.frame.size.height - _lineWidth) / 2 : self.frame.size.height- _circleRadius);//终点
    
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, endLineX, endLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    
    //画已滑动进度的线
    CGContextSetStrokeColorWithColor(context, _slidedLineColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, _lineWidth);//线的宽度
    
    CGFloat slidedLineX = (_direction == ILSliderDirectionHorizonal ? MAX(_circleRadius, (_ratioNum * self.frame.size.width - _circleRadius)) : startLineX);
    
    CGFloat slidedLineY = (_direction == ILSliderDirectionHorizonal ? startLineY : MAX(_circleRadius, (_ratioNum * self.frame.size.height - _circleRadius)));
    
    CGContextMoveToPoint(context, startLineX, startLineY);
    CGContextAddLineToPoint(context, slidedLineX, slidedLineY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
   //外层圆
    CGFloat penWidth = 1.f;
    CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);//画笔颜色
    CGContextSetLineWidth(context, penWidth);//线的宽度
   
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
    
    CGContextSetShadow(context, CGSizeMake(1, 1), 1.f);//阴影
    
    CGFloat circleX = (_direction == ILSliderDirectionHorizonal ? MAX(_circleRadius + penWidth, slidedLineX - penWidth ) : startLineX);
    CGFloat circleY = (_direction == ILSliderDirectionHorizonal ? startLineY : MAX(_circleRadius + penWidth, slidedLineY - penWidth));
    CGContextAddArc(context, circleX, circleY, _circleRadius, 0, 2 * M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    
    //内层圆
    CGContextSetStrokeColorWithColor(context, nil);
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, _circleColor.CGColor);
    CGContextAddArc(context, circleX, circleY, _circleRadius / 2, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

#pragma mark 触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouchPoint:touches];
    [self callbackTouchEnd:YES];
}


- (void)updateTouchPoint:(NSSet*)touches {
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.ratioNum = (_direction == ILSliderDirectionHorizonal ? touchPoint.x : touchPoint.y) / (_direction == ILSliderDirectionHorizonal ? self.frame.size.width : self.frame.size.height);
   // NSLog(@"_ratioNum == %f",_ratioNum);
}

- (void)setRatioNum:(CGFloat)ratioNum {
    if (_ratioNum != ratioNum) {
        _ratioNum = ratioNum;
        
        self.value = _minValue + ratioNum * (_maxValue - _minValue);
    }
  //  NSLog(@"_value = %f",_value);
}

- (void)setValue:(CGFloat)value {
    
    if (value != _value) {
        if (value < _minValue) {
            _value = _minValue;
            return;
        } else if (value > _maxValue) {
            _value = _maxValue;
            return;
        }
        _value = value;
    
        [self setNeedsDisplay];
        
        if (_StateChanged) {
            _StateChanged(value);
        }
    }
}


- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock{
    
    _StateChanged = didChangeBlock;

}

- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock{
    
    _StateEnd = touchEndBlock;
    
}


- (void)callbackTouchEnd:(BOOL)isTouchEnd {
    
    _isSliding = !isTouchEnd;
    
    if (isTouchEnd == YES) {
        _StateEnd(_value);
    }
    
    
}
@end
