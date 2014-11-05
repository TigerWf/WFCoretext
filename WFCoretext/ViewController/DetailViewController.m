//
//  DetailViewController.m
//  WFCoretext
//
//  Created by 吴福虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "DetailViewController.h"
#import "YMTextView.h"


@interface DetailViewController ()

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
