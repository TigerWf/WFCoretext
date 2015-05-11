//
//  E_SettingBottomBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingBottomBar.h"
#import "E_ContantFile.h"
#import "E_CommonManager.h"
#import "ILSlider.h"
#import "E_HUDView.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"

@implementation E_SettingBottomBar
{
    ILSlider *ilSlider;
    UILabel  *showLbl;
    BOOL isFirstShow;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        isFirstShow = YES;
        [self configUI];
    }
    return self;
    
}


- (void)configUI{

    UIButton *menuBtn = [UIButton buttonWithType:0];
    [menuBtn setImage:[UIImage imageNamed:@"reader_cover.png"] forState:0];
    [menuBtn addTarget:self action:@selector(showDrawerView) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.frame = CGRectMake(10, self.frame.size.height - 54, 60, 44);
    [self addSubview:menuBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:0];
    [commentBtn setImage:[UIImage imageNamed:@"reader_comments.png"] forState:0];
    [commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.frame = CGRectMake(self.frame.size.width - 70, self.frame.size.height - 54, 60, 44);
    [self addSubview:commentBtn];
    
    
    _bigFont = [UIButton buttonWithType:0];
    _bigFont.frame = CGRectMake(110 + (self.frame.size.width - 200)/2, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [_bigFont setImage:[UIImage imageNamed:@"reader_font_increase.png"] forState:0];
    _bigFont.backgroundColor = [UIColor clearColor];
   
    [_bigFont addTarget:self action:@selector(changeBig) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_bigFont];
    
    _smallFont = [UIButton buttonWithType:0];
   
    [_smallFont setImage:[UIImage imageNamed:@"reader_font_decrease.png"] forState:0];
    [_smallFont addTarget:self action:@selector(changeSmall) forControlEvents:UIControlEventTouchUpInside];
    _smallFont.frame =  CGRectMake(90, self.frame.size.height - 54, (self.frame.size.width - 200)/2, 44);
    [self addSubview:_smallFont];
    

    showLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, self.frame.size.height - kBottomBarH - 70, self.frame.size.width - 140 , 60)];
    showLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [showLbl setTextColor:[UIColor whiteColor]];
    showLbl.font = [UIFont systemFontOfSize:18];
    showLbl.textAlignment = NSTextAlignmentCenter;
    showLbl.numberOfLines = 2;
    showLbl.alpha = 0.7;
    showLbl.hidden = YES;
    [self addSubview:showLbl];
    
    ilSlider = [[ILSlider alloc] initWithFrame:CGRectMake(50, self.frame.size.height - 54 - 40 - 50 , self.frame.size.width - 100, 40) direction:ILSliderDirectionHorizonal];
    ilSlider.maxValue = 3;
    ilSlider.minValue = 1;
    
    [ilSlider sliderChangeBlock:^(CGFloat value) {
        
        if (!isFirstShow) {
            showLbl.hidden = NO;
            double percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
            showLbl.text = [NSString stringWithFormat:@"第%ld章\n%.1f%@",_currentChapter,percent*100,@"%"];
        }
        isFirstShow = NO;
       
       
    }];
    
    [ilSlider sliderTouchEndBlock:^(CGFloat value) {
        
        showLbl.hidden = YES;
        float percent = (value - ilSlider.minValue)/(ilSlider.maxValue - ilSlider.minValue);
        NSInteger page = (NSInteger)round(percent * _chapterTotalPage);
        if (page == 0) {
            page = 1;
        }
        [_delegate sliderToChapterPage:page];
    }];

    [self addSubview:ilSlider];
   
    //前一章 按钮
    UIButton *preChapterBtn = [UIButton buttonWithType:0];
    preChapterBtn.frame = CGRectMake(5, self.frame.size.height - 54 - 40 - 50, 40, 40);
    preChapterBtn.backgroundColor = [UIColor clearColor];
    [preChapterBtn setTitle:@"上一章" forState:0];
    [preChapterBtn addTarget:self action:@selector(goToPreChapter) forControlEvents:UIControlEventTouchUpInside];
    preChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [preChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:preChapterBtn];
    
    //后一章 按钮
    UIButton *nextChapterBtn = [UIButton buttonWithType:0];
    nextChapterBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 54 - 40 - 50, 40, 40);
    nextChapterBtn.backgroundColor = [UIColor clearColor];
    [nextChapterBtn setTitle:@"下一章" forState:0];
    [nextChapterBtn addTarget:self action:@selector(goToNextChapter) forControlEvents:UIControlEventTouchUpInside];
    nextChapterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [nextChapterBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:nextChapterBtn];
    
    //主题颜色滚动条
    UIScrollView *themeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, self.frame.size.height - 54 - 50 , self.frame.size.width - 60, 40)];
    themeScroll.backgroundColor = [UIColor clearColor];
    [self addSubview:themeScroll];
    
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    
    for (int i = 1; i <= 4; i ++) {
        
        UIButton * themeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        themeButton.layer.cornerRadius = 2.0f;
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        themeButton.frame = CGRectMake(0 + 36*i + (self.frame.size.width - 60 - 6 *36)*(i - 1)/3, 2, 36, 36);
        
        if (i == 1) {
            [themeButton setBackgroundColor:[UIColor whiteColor]];
            
        }else{
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateNormal];
            [themeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%d.png",i]] forState:UIControlStateSelected];
        }
        
        if (i == themeID) {
            themeButton.selected = YES;
        }
        
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateSelected];
        [themeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"reader_bg_s.png"]] forState:UIControlStateHighlighted];
        themeButton.tag = 7000+i;
        [themeButton addTarget:self action:@selector(themeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [themeScroll addSubview:themeButton];

    }
}


- (void)themeButtonPressed:(UIButton *)sender{
    
    [sender setSelected:YES];
    
    for (int i = 1; i <= 5; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:7000+i];
        if (button.tag != sender.tag) {
            [button setSelected:NO];
        }
    }
    
    [_delegate themeButtonAction:self themeIndex:sender.tag-7000];
    [E_CommonManager saveCurrentThemeID:sender.tag-7000];
}

- (void)goToNextChapter{
    
    [_delegate turnToNextChapter];
    
}

- (void)goToPreChapter{
    
    [_delegate turnToPreChapter];

}

#pragma mark - 小
- (void)changeSmall
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize <= MIN_FONT_SIZE) {
        [E_HUDView showMsg:MIN_TIPS inView:self];
        return;
    }
    fontSize--;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
}

- (void)changeBig
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    if (fontSize >= MAX_FONT_SIZE) {
        [E_HUDView showMsg:MAX_TIPS inView:self];
        return;
    }
    fontSize++;
    [E_CommonManager saveFontSize:fontSize];
    [self updateFontButtons];
    [_delegate fontSizeChanged:(int)fontSize];
    [_delegate shutOffPageViewControllerGesture:NO];
    
}


- (void)updateFontButtons
{
    NSUInteger fontSize = [E_CommonManager fontSize];
    _bigFont.enabled = fontSize < MAX_FONT_SIZE;
    _smallFont.enabled = fontSize > MIN_FONT_SIZE;
}

- (void)showDrawerView{
   
    [_delegate callDrawerView];

}

- (void)changeSliderRatioNum:(float)percentNum{
    
    ilSlider.ratioNum = percentNum;

}

- (void)showCommentView{
    
    [_delegate callCommentView];
}




- (void)showToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= kBottomBarH;
    float currentPage = [[NSString stringWithFormat:@"%ld",_chapterCurrentPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_chapterTotalPage] floatValue];
    if (currentPage == 1) {//强行放置头部
        ilSlider.ratioNum = 0;
    }else{
        ilSlider.ratioNum = currentPage/totalPage;
    }
    
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y += kBottomBarH;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
