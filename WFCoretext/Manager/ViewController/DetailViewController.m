//
//  DetailViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "DetailViewController.h"

#import "ContantHead.h"

@interface DetailViewController (){
    
   
    UIButton *btn;
    
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:@"啥都没有点返回啦" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
    
    UITextView *instructT = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 300)];
    instructT.text = @"1.本体在WXViewController里\n\n2.用CTLine去画富文本,WFTextView为CTLine去画\n\n3.根据点击的区域得到CFIndex，然后判断在不在可点击的Range里，然后绘出背景的CGRect区域，并变色\n\n";
    instructT.textColor = [UIColor blueColor];
    instructT.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:instructT];
   
    // Do any additional setup after loading the view.
}

- (void)backToPre{
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
