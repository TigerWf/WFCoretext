//
//  E_ReaderDataSource.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderDataSource.h"
#import "E_CommonManager.h"
#import "E_HUDView.h"


@implementation E_ReaderDataSource

+ (E_ReaderDataSource *)shareInstance{
    
    static E_ReaderDataSource *dataSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        dataSource = [[E_ReaderDataSource alloc] init];

      
    });
    
    return dataSource;
}


- (E_EveryChapter *)openChapter:(NSInteger)clickChapter{

    _currentChapterIndex = clickChapter;
    
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    
    return chapter;
}

- (E_EveryChapter *)openChapter{
    NSUInteger index = [E_CommonManager Manager_getChapterBefore];
    
    _currentChapterIndex = index;
    
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    
    return chapter;
}

- (NSUInteger)openPage{
    
    NSUInteger index = [E_CommonManager Manager_getPageBefore];
    return index;

}


- (E_EveryChapter *)nextChapter{

    if (_currentChapterIndex >= _totalChapter) {
        [E_HUDView showMsg:@"没有更多内容了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex++;
        
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        
        return chapter;
    
    }

}

- (E_EveryChapter *)preChapter{
    
    if (_currentChapterIndex <= 1) {
        [E_HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex --;
        
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        
        return chapter;
    }
}

- (void)resetTotalString{

    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i <  INT_MAX; i ++) {
        
        if (readTextData(i) != nil) {
            
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
            
            
        }else{
            break;
        }
    }

}

- (NSInteger)getChapterBeginIndex:(NSInteger)page{
 
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        
        if (readTextData(i) != nil) {
            
            index += readTextData(i).length;
           // NSLog(@"index == %ld",index);
            
        }else{
            break;
        }
    }
    return index;
}

- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
    
         if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
                
                NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
                NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
               // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
             int temp = 0;
             for (int j = 0; j < _everyChapterRange.count; j ++) {
                 if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                     temp ++;
                 }else{
                     break;
                 }
                 
             }
             
             [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
             [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
             
             NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
                NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [searchResult addObject:completeString];
             
             
             
                [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
                
            }else{
                break;
            }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;

}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender
{
    //获取1到x之间的整数
    if (sender == YES) {
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        
        return location;
        
    }
    else
    {
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
            
        }
        
        return value;
        
    }
    
    
}

static NSString *readTextData(NSUInteger index){
    
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",index];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    return content;
}

@end
