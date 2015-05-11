//
//  E_WebViewControler.m
//  WFReader
//
//  Created by 吴福虎 on 15/3/3.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_WebViewControler.h"


@implementation E_WebViewControler


- (id)initWithSelectString:(NSString *)selectString{
    
    if (self = [super init]) {
        
        NSString *completeString = [selectString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        _selectString = [completeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.view.backgroundColor = [UIColor whiteColor];
        

    }
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [titleLbl setText:@"词霸"];
    [titleLbl setTextColor:[UIColor whiteColor]];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [self.view addSubview:titleLbl];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, 20, 60, 44);
    [backBtn setTitle:@" 返回" forState:0];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
   
    CGRect barFrame = CGRectMake(0, 64, self.view.frame.size.width ,progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_progressView];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iciba.com/%@",_selectString]]];
    [_webView loadRequest:req];

}

- (void)backToFront{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    
    [_progressView setProgress:progress animated:YES];
   
}


@end
