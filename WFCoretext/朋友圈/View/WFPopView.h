//
//  WFPopView.h
//  WFCoretext
//
//  Created by 吴福虎 on 15/5/11.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WFOperationType) {
    WFOperationTypeReply = 0,
    WFOperationTypeLike = 1,
};

typedef void(^DidSelectedOperationBlock)(WFOperationType operationType);

@interface WFPopView : UIView

@property (nonatomic, assign) BOOL shouldShowed;

@property (nonatomic, copy) DidSelectedOperationBlock didSelectedOperationCompletion;

+ (instancetype)initailzerWFOperationView;

- (void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour;

- (void)dismiss;

@end