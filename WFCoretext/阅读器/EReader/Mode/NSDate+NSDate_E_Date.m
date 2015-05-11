//
//  NSDate+NSDate_E_Date.m
//  WFReader
//
//  Created by 吴福虎 on 15/3/3.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "NSDate+NSDate_E_Date.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE	60


@implementation NSDate (NSDate_E_Date)

- (BOOL) isToday{
    
    return [self isEqualToDateTime:[NSDate date]];
}

- (BOOL) isEqualToDateTime: (NSDate *) aDate{
    
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (NSInteger) minutesAfterDate: (NSDate *) aDate{
    
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate{
    
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}



@end
