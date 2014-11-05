//
//  NSString+NSString_ILExtension.h
//  ILCoretext
//
//  Created by 阿虎 on 14/10/22.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_ILExtension)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;


- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;

@end
