//
//  E_Paging.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "E_ContantFile.h"
/**
 *  分页计算并给予内容等
 */

@interface E_Paging : NSObject

@property (nonatomic, copy)               NSString   *contentText;
@property (nonatomic, unsafe_unretained)  NSUInteger  contentFont;
@property (nonatomic, unsafe_unretained)  CGSize     textRenderSize;

/**
 *  分页
 */
- (void)paginate;



/**
 *  一共分了多少页
 *
 *  @return 一章所分的页数
 */
- (NSUInteger)pageCount;



/**
 *  获得page页的文字内容
 *
 *  @param page 页
 *
 *  @return 内容
 */
- (NSString *)stringOfPage:(NSUInteger)page;

/**
 *  根据当前的页码计算范围 - 目的是为了变字号的时候内容偏移不要太多
 *
 *  @param page 当前页码
 *
 *  @return 范围
 */
- (NSRange)rangeOfPage:(NSUInteger)page;

@end
