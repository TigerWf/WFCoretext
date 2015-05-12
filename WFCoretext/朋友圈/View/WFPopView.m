//
//  WFPopView.m
//  WFCoretext
//
//  Created by 阿虎 on 15/5/11.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "WFPopView.h"

#define kXHALbumOperationViewSize CGSizeMake(120, 34)
#define kXHAlbumSpatorY 5

@interface WFPopView ()

@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, assign) CGRect targetRect;

@end

@implementation WFPopView

+ (instancetype)initailzerWFOperationView {
    WFPopView *operationView = [[WFPopView alloc] initWithFrame:CGRectZero];
    return operationView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        [self addSubview:self.replyButton];
        [self addSubview:self.likeButton];
    }
    return self;
}

#pragma mark - Action

- (void)operationDidClicked:(UIButton *)sender {
    [self dismiss];
    if (self.didSelectedOperationCompletion) {
        self.didSelectedOperationCompletion(sender.tag);
    }
}

#pragma mark - Propertys

- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.tag = 0;
        [_replyButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _replyButton.frame = CGRectMake(0, 0, kXHALbumOperationViewSize.width / 2.0, kXHALbumOperationViewSize.height);
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.tag = 1;
        [_likeButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.frame = CGRectMake(CGRectGetMaxX(_replyButton.frame), 0, CGRectGetWidth(_replyButton.bounds), CGRectGetHeight(_replyButton.bounds));
        [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _likeButton;
}

#pragma mark - 公开方法

- (void)showAtView:(UITableView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour {
    self.targetRect = targetRect;
    if (self.shouldShowed) {
        return;
    }
    
    [containerView addSubview:self];
    
    CGFloat width = kXHALbumOperationViewSize.width;
    CGFloat height = kXHALbumOperationViewSize.height;
    
    self.frame = CGRectMake(targetRect.origin.x, targetRect.origin.y - kXHAlbumSpatorY, 0, height);
    self.shouldShowed = YES;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(targetRect.origin.x - width, targetRect.origin.y - kXHAlbumSpatorY, width, height);
    } completion:^(BOOL finished) {
        [_replyButton setTitle:@"评论" forState:UIControlStateNormal];
        [_likeButton setTitle:(isFavour?@"取消赞":@"赞") forState:UIControlStateNormal];
    }];
}

- (void)dismiss {
    if (!self.shouldShowed) {
        return;
    }
    
    self.shouldShowed = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        [_replyButton setTitle:nil forState:UIControlStateNormal];
        [_likeButton setTitle:nil forState:UIControlStateNormal];
        CGFloat height = kXHALbumOperationViewSize.height;
        self.frame = CGRectMake(self.targetRect.origin.x, self.targetRect.origin.y - kXHAlbumSpatorY, 0, height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

@end