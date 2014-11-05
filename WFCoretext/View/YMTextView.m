//
//  YMTextView.m
//  YMRichView
//
//  Created by 阿虎 on 14/10/24.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//
/**
 *  CTFrame画富文本
 *
 *
 */
#import "YMTextView.h"
#import "ContantHead.h"
#import "ILRegularExpressionManager.h"
#import "NSArray+NSArray_ILExtension.h"
#import "NSString+NSString_ILExtension.h"


#define ILTextFont  15
#define ILTextColor [UIColor blueColor]
#define ILTextLineSpace 8.0
#define offset_X 0
#define offset_Y 0




@implementation YMTextView
{
    NSAttributedString *attrString;
    NSInteger _fontS;
    UIColor  *_fontC;
    NSInteger _lineS;
    
    NSString *_oldString;//未处理之前的string ，为了拿表情的名字 （[em:02:]中的02）
    NSString *_newString;//处理后的string，此时表情的字符已被空格代替
    
    NSMutableArray *_nameArray;//表情名字数组 为了和图片对应上
    NSArray *_emotionRanges;//表情range数组，为了找出表情位置
    
    CTFrameRef workFrame;
    
    NSMutableArray *_selectionsViews;//存点击url或者电话号码的背景的view的数组
    
   

}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //  NSLog(@"HHHHHHHHHHHHHHH");
        self.backgroundColor = [UIColor clearColor];
        
        
        _isDraw = YES;
        _fontS = ILTextFont;
        _fontC = ILTextColor;
        _lineS = ILTextLineSpace;
        _selectionsViews = [NSMutableArray arrayWithCapacity:0];
        _attributedData = [NSMutableArray arrayWithCapacity:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMyself:)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
             
   
        
    }
    return self;
}

- (void)dealloc{
  
    if (_framesetter != NULL){
        
        CFRelease(_framesetter);
        
    }
    
    if (workFrame != NULL) {
        
        CFRelease(workFrame);
    }
//arc 不可调用super dealloc 但是会走dealloc
}

- (void)drawRect:(CGRect)rect{
    
      
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
 
    CGMutablePathRef path = CGPathCreateMutable();
   
    CGRect iRect = CGRectInset(CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height ), offset_X, offset_Y);
    CGPathAddRect(path, NULL, iRect);//irect添入CGPath
    
 
    
// [self updateFramesetterIfNeeded];
    
     workFrame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
    [self drawEmotion];
    
    CTFrameDraw(workFrame, context);//画
    CFRelease(path);//释放


}

- (void)drawEmotion{
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _emotionRanges.count; i ++) {
        
        NSRange emRange = NSRangeFromString([_emotionRanges objectAtIndex:i]);
        CGRect emRect;
        NSArray *array = [self getSelectedCGRect:workFrame andClickRange:emRange];
        if (array.count) {
            emRect = CGRectFromString((NSString *)[array objectAtIndex:0]);
        }
        
        NSString *emName = [_nameArray objectAtIndex:i];
        UIImageView *emImageView = [[UIImageView alloc] initWithFrame:emRect];
        emImageView.image = [self getEmotionForKey:emName];
        [self addSubview:emImageView];
        
    }

}

// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key_
{
    NSString *nameStr = [NSString stringWithFormat:@"%@.png",key_];
    return [UIImage imageNamed:nameStr];
}

#pragma mark - 根据range计算该range区间内文字的CGRect，因为可能不在同一行，所以N行的CGRect放入数组返回

- (NSMutableArray *)getSelectedCGRect:(CTFrameRef)senderFrame andClickRange:(NSRange)tempRange
{
    NSMutableArray *clickRects = [[NSMutableArray alloc] init];
    NSArray *lines = (NSArray*)CTFrameGetLines(senderFrame); //获得行数数组
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins(senderFrame, CFRangeMake(0, [lines count]), origins);//每行的起始位置
    NSInteger count = [lines count];
    for (int i = 0; i < count; i++) { //一行行处理
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:tempRange];
        if (intersection.length > 0)
        {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
            
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(baselineOrigin.x + xStart + offset_X, baselineOrigin.y + offset_Y - ascent, xEnd -  xStart , ascent + descent);//所画选择之后背景的 大小 和起始坐标
            [clickRects addObject:NSStringFromCGRect(selectionRect)];
            
        }
        
    }
    // NSLog(@"clickRects == %@",clickRects);
    
    free(origins);
    return clickRects;
    
    
}

//超出1行 处理
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location)
    {
        NSRange tmp = first;
        first = second;
        second = tmp;
    }
    if (second.location < first.location + first.length)
    {
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }
    return result;
}



- (void)updateFramesetterIfNeeded
{
    
   if (_framesetter != NULL) CFRelease(_framesetter);
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
        
    
}


- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString{

    _oldString = oldString;
    _newString = newString;
    if (_isDraw == NO) {
        return;
    }
    [self setNeedsDisplay];

}


- (CGFloat)getSuggestedHeight{
    
    CGSize suggestedSize = [self suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];

    return suggestedSize.height;
    
}

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
    CGSize suggestedSize;
    [self updateFramesetterIfNeeded];
    if (_framesetter == NULL) {
        return CGSizeZero;
    }
    suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter, CFRangeMake(0, 0), NULL, size, NULL);
    suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
    return suggestedSize;
}

- (void)fitToSuggestedHeight
{
    CGSize suggestedSize = [self suggestedSizeConstrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
    CGRect viewFrame = self.frame;
    viewFrame.size.height = suggestedSize.height;
    self.frame = viewFrame;
}


- (NSAttributedString *)attributedString{
    
   // NSLog(@"多少次啊");
     NSArray *itemIndexes = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:_oldString];
    
    
    _nameArray = [_oldString itemsForPattern:EmotionItemPattern captureGroupIndex:1];
   // NSString *newString = [_oldString replaceCharactersAtIndexes:itemIndexes
                                                  //     withString:PlaceHolder];
    
    
    
    
    _emotionRanges = [itemIndexes offsetRangesInArrayBy:[PlaceHolder length]];

    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_newString];
    
    for (int i = 0; i < _attributedData.count; i ++) {
        
     NSString *str = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
    
    [attrStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor redColor].CGColor) range:NSRangeFromString(str)];
        
    }
    
    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"),15.0, NULL);
    
    [attrStr addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[_newString length])];
   
  
    
    CGFloat lineSpace = _lineS;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(CGFloat);
    lineSpaceStyle.value=&lineSpace;
    
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        
        lineSpaceStyle,
        lineBreakMode
        
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
    
    [attrStr addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(0, [_newString length])];
    
    
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = YMRunDelegateDeallocCallback;
    imageCallbacks.getAscent = YMRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = YMRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = YMRunDelegateGetWidthCallback;
    //创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, NULL);
  
    for(NSInteger i = 0; i < [_emotionRanges count]; i++)
    {
        NSRange range = NSRangeFromString([_emotionRanges objectAtIndex:i]);
        NSString *emotionName = [_nameArray objectAtIndex:i];
        [attrStr addAttribute:AttributedImageNameKey value:emotionName range:range];
        [attrStr addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
    }
  
    
    CFRelease(runDelegate);
    CFRelease(paragraphStyle);

    return attrStr;

}

//CTRun的回调，销毁内存的回调
void YMRunDelegateDeallocCallback( void* refCon ){
    
}

//CTRun的回调，获取高度
CGFloat YMRunDelegateGetAscentCallback( void *refCon ){
    
    return 13;
}

CGFloat YMRunDelegateGetDescentCallback(void *refCon){
    return 0;
}
//CTRun的回调，获取宽度
CGFloat YMRunDelegateGetWidthCallback(void *refCon){
    
    return 15;
}



#pragma mark -点击自己
- (void)tapMyself:(UITapGestureRecognizer *)gesture{
 
    CGPoint point = [gesture locationInView:self];
    
    if (_framesetter) {
        
    }else{
        _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect iRect = CGRectInset(CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height ), offset_X, offset_Y);
    CGPathAddRect(path, NULL, iRect);//irect添入CGPath
    
    CTFrameRef ctframe = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
    CGPathRelease(path);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(ctframe);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    BOOL isSelected = NO;//判断是否点到selectedRange内 默认没点到
    if (lineCount != 0) {
        
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
        
        for (int i = 0; i < lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
            
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent, descent;
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            
            CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
            
            if (CGRectContainsPoint(lineFrame, point)) { //没进此判断 说明没点到文字 ，点到了文字间距处
                
                CFIndex index = CTLineGetStringIndexForPosition(line, point);
                
                if ([self judgeIndexInSelectedRange:index withWorkFrame:ctframe] == YES) {//点到selectedRange内
                    
                    isSelected = YES;
                    
                }else{
                    //点在了文字上 但是不在selectedRange内
                    
                }
            }
        }
    }
    
    CFRelease(ctframe);
    
    if (isSelected == YES) {
        
    }else{
        [self clickAllContext];
        return;
        
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_selectionsViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    });

}

- (void)clickAllContext{
    
    UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 2)];
    myselfSelected.tag = 10101;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = kSelf_SelectedColor;
    [_delegate clickMyself:@""];
    
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if ([weakSelf viewWithTag:10101]) {
           
            [[weakSelf viewWithTag:10101] removeFromSuperview];
        }
        
    });
    
}

- (BOOL)judgeIndexInSelectedRange:(CFIndex) index withWorkFrame:(CTFrameRef)workctFrame{
    
    for (int i = 0; i < _attributedData.count; i ++) {
        
        NSString *key = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
        NSRange keyRange = NSRangeFromString(key);
        if (index>=keyRange.location && index<= keyRange.location + keyRange.length) {
            NSMutableArray *arr = [self getSelectedCGRect:workctFrame andClickRange:NSRangeFromString(key)];
            [self drawViewFromRects:arr withDictValue:[[_attributedData objectAtIndex:i] valueForKey:key]];
            
            NSString *feedString = [[_attributedData objectAtIndex:i] valueForKey:key];
            [_delegate clickMyself:feedString];
            return YES;
        }
        
        
    }
    
    return NO;
    
    
}

- (void)drawViewFromRects:(NSArray *)array withDictValue:(NSString *)value
{
    //用户名可能超过1行的内容 所以记录在数组里，有多少元素 就有多少view
    // selectedViewLinesF = array.count;
    
    for (int i = 0; i < [array count]; i++) {
        
        UIView *selectedView = [[UIView alloc] init];
        selectedView.frame = CGRectFromString([array objectAtIndex:i]);
        selectedView.backgroundColor = kUserName_SelectedColor;
        
        [self addSubview:selectedView];
        [_selectionsViews addObject:selectedView];
        
    }
    
}

@end
