//
//  NSString+NSString_ILExtension.m
//  ILCoretext
//
//  Created by 阿虎 on 14/10/22.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "NSString+NSString_ILExtension.h"

@implementation NSString (NSString_ILExtension)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}

- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
       
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
       
        return results;
    }
    
    return nil;
}


@end
