//
//  ILSlider.h
//  ILSlider
//
//  Created by 吴福虎 on 14-10-17.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchStateEnd) (CGFloat);
typedef void(^TouchStateChanged) (CGFloat);

typedef enum {
    ILSliderDirectionHorizonal  =   0,
    ILSliderDirectionVertical   =   1
} ILSliderDirection;

@interface ILSlider : UIControl


@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat ratioNum;//滑动的比值

@property (nonatomic, assign) ILSliderDirection direction;//方向

@property (nonatomic, copy) TouchStateChanged StateChanged;
@property (nonatomic, copy) TouchStateEnd StateEnd;


- (id)initWithFrame:(CGRect)frame direction:(ILSliderDirection)direction;

- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock;

- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock;


@end
