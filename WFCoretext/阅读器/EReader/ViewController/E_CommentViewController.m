//
//  E_CommentViewController.m
//  WFReader
//
//  Created by 阿虎 on 15/2/27.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_CommentViewController.h"

@interface E_CommentViewController ()

@end

@implementation E_CommentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    [titleLbl setText:@"评论页"];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLbl];

    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor blackColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 88)];
    introLbl.text = @"初始页，点击朋友圈";
    introLbl.textAlignment = NSTextAlignmentCenter;
    introLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:introLbl];

}




- (void)backToFront{
   
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
