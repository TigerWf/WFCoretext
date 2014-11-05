//
//  ILRegularExpressionManager.h
//  ILCoretext
//
//  Created by 阿虎 on 14/10/22.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILRegularExpressionManager : NSObject

+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;

+ (NSMutableArray *)matchMobileLink:(NSString *)pattern;

+ (NSMutableArray *)matchWebLink:(NSString *)pattern;

@end
