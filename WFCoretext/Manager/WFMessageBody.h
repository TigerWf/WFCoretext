//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 吴福虎 on 15/4/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFMessageBody : NSObject

@property (nonatomic,copy) NSString *posterImgstr;

@property (nonatomic,copy) NSString *posterName;

@property (nonatomic,copy) NSString *posterIntro;

@property (nonatomic,copy) NSString *posterContent;

@property (nonatomic,strong) NSArray *posterPostImage;

@property (nonatomic,strong) NSMutableArray *posterReplies;

@end
