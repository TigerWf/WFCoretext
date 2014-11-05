//
//  YMTextData.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTextData : NSObject

@property (nonatomic,strong) NSMutableArray *replyDataSource;//回复内容数据源（未处理）
@property (nonatomic,assign) float           replyHeight;//回复高度
@property (nonatomic,assign) float           shuoshuoHeight;//折叠说说高度
@property (nonatomic,assign) float           unFoldShuoHeight;//展开说说高度

@property (nonatomic,strong) NSMutableArray *completionReplySource;//回复内容数据源（处理）
@property (nonatomic,strong) NSMutableArray *attributedData;//YMTextView附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataWF;//WFTextView附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *showImageArray;//图片数组
@property (nonatomic,assign) float           showImageHeight;//展示图片的高度

@property (nonatomic,assign) BOOL            foldOrNot;//是否折叠
@property (nonatomic,strong) NSString       *showShuoShuo;//说说部分
@property (nonatomic,strong) NSString       *completionShuoshuo;//说说部分（处理后）
@property (nonatomic,assign) BOOL            islessLimit;//是否小于最低限制 宏定义最低限制是 limitline
/**
 *  计算高度
 *
 *  @param sizeWidth view 宽度
 *
 *  @return 返回高度
 */
- (float) calculateReplyHeightWithWidth:(float)sizeWidth;

/**
 *  计算折叠还是展开的说说的高度
 *
 *  @param sizeWidth 宽度
 *  @param isUnfold  展开与否
 *
 *  @return 高度
 */
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold;



@end
