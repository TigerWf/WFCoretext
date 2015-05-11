//
//  E_ReaderView.h
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "E_MagnifiterView.h"
#import "E_CursorView.h"

/**
 *  显示文本类
 */

@protocol E_ReaderViewDelegate <NSObject>

- (void)shutOffGesture:(BOOL)yesOrNo;
- (void)hideSettingToolBar;
- (void)ciBa:(NSString *)ciBasString;

@end

@interface E_ReaderView : UIView

@property(unsafe_unretained, nonatomic)NSUInteger font;
@property(copy, nonatomic)NSString *text;

@property (strong, nonatomic) E_CursorView *leftCursor;
@property (strong, nonatomic) E_CursorView *rightCursor;
@property (strong, nonatomic) E_MagnifiterView *magnifierView;
@property (assign, nonatomic) id<E_ReaderViewDelegate>delegate;
@property (strong, nonatomic) UIImage  *magnifiterImage;
@property (copy  , nonatomic) NSString *keyWord;

- (void)render;

@end
