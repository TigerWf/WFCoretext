//
//  HXReplyInputView.h
//  Hongxiu
//
//  Created by 吴福虎 on 14-8-18.
//  Copyright (c) 2014年 FeeTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputDelegate <NSObject>

- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag;
- (void)destorySelf;

@end

@interface YMReplyInputView : UIView<UITextViewDelegate>
{
    CGFloat topGap;
    CGFloat keyboardAnimationDuration;
    UIViewAnimationCurve keyboardAnimationCurve;
    CGFloat keyboardHeight;
    int inputHeight;
    int inputHeightWithShadow;
    BOOL autoResizeOnKeyboardVisibilityChanged;
    UIView *tapView;
   
    
}


@property (strong, nonatomic) UIButton* sendButton;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UILabel* lblPlaceholder;
@property (strong, nonatomic) UIImageView* inputBackgroundView;
@property (strong, nonatomic) UITextField *textViewBackgroundView;
@property (assign, nonatomic) BOOL autoResizeOnKeyboardVisibilityChanged;
@property (readwrite, nonatomic) CGFloat keyboardHeight;
@property (assign, nonatomic) id<InputDelegate>delegate;
@property (assign, nonatomic) NSInteger replyTag;



- (NSString*)text;
- (void)setText:(NSString*)text;
- (void)setPlaceholder:(NSString*)text;
- (void)showCommentView;
- (id) initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
- (void)disappear;


@end
