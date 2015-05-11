//
//  DetailViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "DetailViewController.h"
#import "E_ScrollViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:@"我是返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pushBtn = [UIButton buttonWithType:0];
    pushBtn.frame = CGRectMake(40, 90, self.view.frame.size.width - 80, 100);
    [pushBtn setTitle:@"go to Reader" forState:0];
    pushBtn.backgroundColor = [UIColor cyanColor];
    [pushBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
   
    // Do any additional setup after loading the view.
}

- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)push{
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    [self presentViewController:loginvctrl animated:NO completion:nil];
    
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
