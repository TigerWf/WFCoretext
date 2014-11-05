//
//  YMTextView.h
//  YMRichView
//
//  Created by 阿虎 on 14/10/24.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//
/**
 *  CTFrame 去画
 *
 */

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@protocol ILCoretextDelegate <NSObject>

- (void)clickMyself:(NSString *)clickString;

@end

@interface YMTextView : UIView

@property (nonatomic, assign) NSInteger fontSize;   //字体大小
@property (nonatomic, strong) UIColor  *fontColor;  //字体颜色
@property (nonatomic, assign) NSInteger lineSpace;  //行距
@property (nonatomic, assign) BOOL      isDraw;//是否画
@property (nonatomic) CTFramesetterRef framesetter;

/**
 *  ////里面数据为字典 ，字典key range    value string
 */
@property (nonatomic, strong) NSMutableArray *attributedData;

@property (nonatomic, assign) id<ILCoretextDelegate>delegate;

/**
 *  自适应高度
 */
- (void)fitToSuggestedHeight;

/**
 *  获得自适应的高度
 *
 *  @return 返回高度
 */
- (CGFloat)getSuggestedHeight;


/**
 *  设置text内容
 *
 *  @param oldString 为处理之前的text
 *  @param newString 处理之后的text
 */
- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;


@end
