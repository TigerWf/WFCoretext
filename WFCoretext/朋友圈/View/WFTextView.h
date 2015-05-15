//
//  WFTextView.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/31.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//
/**
 *  CTLine 去画
 *
 */

#import <UIKit/UIKit.h>

@protocol WFCoretextDelegate <NSObject>

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index;

- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index;


@end

@interface WFTextView : UIView

@property (nonatomic,strong) NSAttributedString *attrEmotionString;
@property (nonatomic,strong) NSArray *emotionNames;
@property (nonatomic,assign) BOOL isDraw;
@property (nonatomic,assign) BOOL isFold;//是否折叠
@property (nonatomic,strong) NSMutableArray *attributedData;
@property (nonatomic,assign) int textLine;
@property (nonatomic,assign) id<WFCoretextDelegate>delegate;
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@property (nonatomic,assign) BOOL canClickAll;//是否可点击整段文字
@property (nonatomic,assign) NSInteger replyIndex;

@property (nonatomic,strong) UIColor *textColor;

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

- (int)getTextLines;

- (float)getTextHeight;

@end
