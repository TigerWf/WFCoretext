//
//  YMTextData.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "YMTextData.h"
#import "ContantHead.h"
#import "ILRegularExpressionManager.h"
#import "NSString+NSString_ILExtension.h"

#import "WFTextView.h"

@implementation YMTextData{
    
    BOOL isReplyView;
    int tempInt;
}



- (id)init
{
    self = [super init];
    if (self) {
        
        self.completionReplySource = [[NSMutableArray alloc] init];
        self.attributedData = [[NSMutableArray alloc] init];
        self.attributedDataWF = [[NSMutableArray alloc] init];
        self.showImageArray = [[NSMutableArray alloc] init];
        _foldOrNot = YES;
        _islessLimit = NO;
    }
    return self;
}

//计算replyview高度
- (float) calculateReplyHeightWithWidth:(float)sizeWidth{
    
    
    isReplyView = YES;
    float height = .0f;
    //NSLog(@" === %@",self.replyDataSource);
    
    for (int i = 0; i < self.replyDataSource.count; i ++ ) {
        
        tempInt = i;
        
        NSString *matchString = [self.replyDataSource objectAtIndex:i];
        
        NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
        
        NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                           withString:PlaceHolder];
        //存新的
        [self.completionReplySource addObject:newString];
        
        
        
        [self matchString:newString fromView:isReplyView];
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)];
        
        _ilcoreText.isDraw = NO;
        
        [_ilcoreText setOldString:[self.replyDataSource objectAtIndex:i] andNewString:newString];
        
        height =  height + [_ilcoreText getTextHeight] + 5;
        
    }
    
    [self calculateShowImageHeight];
    
    return height;
    
}
//图片高度
- (void)calculateShowImageHeight{
    
    if (self.showImageArray.count == 0) {
        self.showImageArray = 0;
    }else{
        self.showImageHeight = (ShowImage_H + 10) * ((self.showImageArray.count - 1)/3 + 1);
    }
    
}

- (void)matchString:(NSString *)dataSourceString fromView:(BOOL) isYMOrNot{
    
    if (isYMOrNot == YES) {
        
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
        
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            
            [totalArr addObject:[mobileLink objectAtIndex:i]];
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [totalArr addObject:[webLink objectAtIndex:i]];
        }
        
        //******自行添加**********
        
        if (_defineAttrData.count != 0) {
            NSArray *tArr = [_defineAttrData objectAtIndex:tempInt];
            for (int i = 0; i < [tArr count]; i ++) {
                NSString *string = [dataSourceString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
            }
            
        }
       
        
        //***********************
        [self.attributedData addObject:totalArr];
        
        
    }else{
        
        //**********号码******
        
        NSMutableArray *mobileLink = [ILRegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            
            [self.attributedDataWF addObject:[mobileLink objectAtIndex:i]];
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [ILRegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [self.attributedDataWF addObject:[webLink objectAtIndex:i]];
        }
        
        //******自行添加**********
        //        NSString *string = [dataSourceString substringWithRange:NSMakeRange(0, 3)];
        //        [self.attributedDataWF addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSMakeRange(0, 3))]];
        //**********************
    }
    
    
}

//说说高度
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold{
    
    isReplyView = NO;
    
    NSString *matchString =  _showShuoShuo;
    
    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    //存新的
    self.completionShuoshuo = newString;
    
    [self matchString:newString fromView:isReplyView];
    
    WFTextView *_wfcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)];
    
    _wfcoreText.isDraw = NO;
    
    [_wfcoreText setOldString:_showShuoShuo andNewString:newString];
    
    if ([_wfcoreText getTextLines] <= limitline) {
        self.islessLimit = YES;
    }else{
        self.islessLimit = NO;
    }
    
    if (!isUnfold) {
        
        _wfcoreText.isFold = YES;
        
    }else{
        
        _wfcoreText.isFold = NO;
        
        
    }
    return [_wfcoreText getTextHeight];
    
    
}


@end
