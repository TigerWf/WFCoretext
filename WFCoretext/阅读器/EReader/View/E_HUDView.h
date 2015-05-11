//
//  ZHX_HUDView.h
//  ZHX
//
//  Created by 吴福虎 on 14-1-6.
//  Copyright (c) 2014年 阿虎. All rights reserved.
//
/*
 弹出视图
 */

#import <UIKit/UIKit.h>

@interface E_HUDView : UIView
{
    UIFont *msgFont;
}
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, retain) UILabel  *labelText;
@property (nonatomic, assign) float leftMargin;
@property (nonatomic, assign) float topMargin;
@property (nonatomic, assign) float animationLeftScale;
@property (nonatomic, assign) float animationTopScale;
@property (nonatomic, assign) float totalDuration;

+ (void)showMsg:(NSString *)msg inView:(UIView*)theView;

@end
