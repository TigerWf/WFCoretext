//
//  E_CursorView.m
//  WFReader
//
//  Created by 阿虎 on 15/1/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_CursorView.h"
#define kE_CursorWidth 2

@implementation E_CursorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor{
    self = [super init];
    if (self) {
        _direction = type;
        _cursorHeight = cursorHeight;
        _cursorColor = drawColor;
        self.clipsToBounds = NO;
        
    }
    return self;

}


- (void)setSetupPoint:(CGPoint)setupPoint{
    
    self.backgroundColor = _cursorColor;
    
    if (_dragDot) {
        [_dragDot removeFromSuperview];
        _dragDot = nil;
    }
    
    _dragDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_drag-dot.png"]];
    
    if (_direction == CursorLeft) {
        self.frame = CGRectMake(setupPoint.x - kE_CursorWidth, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-7, -8, 15, 17);
        
    }else{
        self.frame = CGRectMake(setupPoint.x, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-6, _cursorHeight - 8, 15, 17);
    }
    [self addSubview:_dragDot];
}

- (void)dealloc{
   
    
}
@end
