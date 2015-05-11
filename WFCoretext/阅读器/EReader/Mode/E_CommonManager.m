//
//  E_CommonManager.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_CommonManager.h"
#import "E_ContantFile.h"
#import "E_Mark.h"

@implementation E_CommonManager


+ (NSInteger)Manager_getReadTheme{
   
    NSString *themeID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVETHEME];
    
    if (themeID == nil) {
        
        return 1;
        
    }else{
        
        return [themeID integerValue];
        
    }

}


+ (void)saveCurrentThemeID:(NSInteger)currentThemeID{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentThemeID) forKey:SAVETHEME];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSUInteger)Manager_getPageBefore{
    
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVEPAGE];
    
    if (pageID == nil) {
        
        return 0;
        
    }else{
        
        return [pageID integerValue];
        
    }

}

+ (void)saveCurrentPage:(NSInteger)currentPage{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:SAVEPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (NSUInteger)Manager_getChapterBefore
{
    NSString *chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:OPEN];
    
    if (chapterID == nil) {
        
        return 1;
        
    }else{
        
        return [chapterID integerValue];
    
    }

}

+ (void)saveCurrentChapter:(NSInteger)currentChapter{
   
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];

}



+ (NSUInteger)fontSize
{
    NSUInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE];
    if (fontSize == 0) {
        fontSize = 20;
    }
    return fontSize;
}

+ (void)saveFontSize:(NSUInteger)fontSize
{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:FONT_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark- 书签保存

+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    E_Mark *eMark = [[E_Mark alloc] init];
    eMark.markRange   = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%zi",currentChapter];
    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    
  //  NSLog(@"chapterRange == %@",NSStringFromRange(chapterRange));
    
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:epubBookName];
            
        }else{
        
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
        }
       
       [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
       
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
           
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) && (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) && ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]])) {
        
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
                
            }
        }
    }
    
}

+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        int k = 0;
        for (int i = 0; i < oldSaveArray.count; i ++) {
             E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
            
            if ((NSRangeFromString(e.markRange).location >= currentRange.location) && (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) && [e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]]) {
                k++;
            }else{
               // k++;
            }
        }
        if (k >= 1) {
           return YES;
        }else{
           return NO;
        }
}

+ (NSMutableArray *)Manager_getMark{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
    
    }

}

@end
