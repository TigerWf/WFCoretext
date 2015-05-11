//
//  NSDate+NSDate_E_Date.h
//  WFReader
//
//  Created by 吴福虎 on 15/3/3.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_E_Date)

/*
 是否是今天
 */
- (BOOL)isToday;

/*
 时间差
 */
- (NSInteger) minutesAfterDate : (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;


@end
