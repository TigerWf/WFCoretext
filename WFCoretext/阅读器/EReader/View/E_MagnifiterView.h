//
//  E_MagnifiterView.h
//  WFReader
//
//  Created by 阿虎 on 15/1/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  放大镜类
 */
@interface E_MagnifiterView : UIView

@property (weak, nonatomic) UIView *viewToMagnify;
@property (nonatomic) CGPoint touchPoint;

@end
