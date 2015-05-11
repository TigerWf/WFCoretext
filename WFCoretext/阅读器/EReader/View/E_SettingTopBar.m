//
//  E_SettingBar.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/13.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SettingTopBar.h"

@implementation E_SettingTopBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
        [self configUI];
    }
    return self;

}


- (void)configUI{
   
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];

    UIButton *multifunctionBtn = [UIButton buttonWithType:0];
    multifunctionBtn.frame = CGRectMake(self.frame.size.width - 10 - 60, 20, 60, 44);
    [multifunctionBtn setImage:[UIImage imageNamed:@"reader_more.png"] forState:0];
    [multifunctionBtn setTitleColor:[UIColor whiteColor] forState:0];
    [multifunctionBtn addTarget:self action:@selector(multifunction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:multifunctionBtn];


}


- (void)backToFront{
    
    [_delegate goBack];
}

- (void)multifunction{
   
    [_delegate showMultifunctionButton];
    
}
    

- (void)showToolBar{
   
    CGRect newFrame = self.frame;
    newFrame.origin.y += 64;
    [UIView animateWithDuration:0.18 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)hideToolBar{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y -= 64;
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
