//
//  E_ReaderDataSource.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E_EveryChapter.h"
/**
 *  书籍内容来源部分   退出的时候页码存储未写，根据实际情况去存
 */
@interface E_ReaderDataSource : NSObject

//当前章节数
@property (unsafe_unretained, nonatomic) NSUInteger currentChapterIndex;

//总章节数
@property (unsafe_unretained, nonatomic) NSUInteger totalChapter;

@property (copy             , nonatomic) NSMutableString  *totalString;//全文

@property (strong           , nonatomic) NSMutableArray   *everyChapterRange;//每章节的range
/**
 *  单例
 *
 *  @return 实例
 */
+ (E_ReaderDataSource *)shareInstance;


/**
 *  通过传入id来获取章节信息
 *
 *  @return 章节类
 */
- (E_EveryChapter *)openChapter;

/**
 *  章节跳转
 *
 *  @param clickChapter 跳转章节数
 *
 *  @return 该章节
 */
- (E_EveryChapter *)openChapter:(NSInteger)clickChapter;

/**
 *  打开得页数
 *
 *  @return 返回页数
 */
- (NSUInteger)openPage;

/**
 *  获得下一章内容
 *
 *  @return 章节类
 */
- (E_EveryChapter *)nextChapter;


/**
 *  获得上一章内容
 *
 *  @return 章节类
 */
- (E_EveryChapter *)preChapter;

/**
 *  全文搜索
 *
 *  @param keyWord 要搜索的关键字
 *
 *  @return 搜索的关键字所在的位置
 */
- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord;


/**
 *  获得全文
 */
- (void)resetTotalString;


/**
 *  获得指定章节的第一个字在整篇文章中的位置
 *
 *  @param page 指定章节
 *
 *  @return 位置
 */
- (NSInteger)getChapterBeginIndex:(NSInteger)page;

@end
