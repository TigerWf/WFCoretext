//
//  E_CommonManager.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E_ContantFile.h"
/**
 *  公共管理类
 */


@interface E_CommonManager : NSObject


/**
 *  保存页码
 *
 *  @param currentChapter 现页码
 */
+ (void)saveCurrentPage:(NSInteger)currentPage;



/**
 *  获得之前看的页码
 *
 *  @return 页码数
 */
+ (NSUInteger)Manager_getPageBefore;

/**
 *  保存章节
 *
 *  @param currentChapter 现章节
 */
+ (void)saveCurrentChapter:(NSInteger)currentChapter;

/**
 *  获得主题背景
 *
 *  @return 主题背景id
 */
+ (NSInteger)Manager_getReadTheme;


/**
 *  保存主题ID
 *
 *  @param currentThemeID 主题ID
 */
+ (void)saveCurrentThemeID:(NSInteger)currentThemeID;

/**
 *  获得之前看的章节
 *
 *  @return 章节数
 */
+ (NSUInteger)Manager_getChapterBefore;

/**
 *  获得字号
 *
 *  @return 字号大小
 */
+ (NSUInteger)fontSize;


/**
 *  存储字号
 *
 *  @param fontSize 存储的字号大小
 */
+ (void)saveFontSize:(NSUInteger)fontSize;


/**
 *  检查当前页是否加了书签
 *
 *  @param currentRange 当前range
 *  @param currentChapter
 *  @return 是否加了书签
 */
+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter;

/**
 *  保存书签
 *
 *  @param currentChapter 当前章节
 *  @param chapterRange   当前页起始的一段文字的range
 */
+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent;

/**
 *  获得书签数组
 *
 *  @return 书签数组
 */
+ (NSMutableArray *)Manager_getMark;

@end
