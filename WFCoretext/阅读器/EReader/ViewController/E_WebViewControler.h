//
//  E_WebViewControler.h
//  WFReader
//
//  Created by 吴福虎 on 15/3/3.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
/**
 *  浏览器视图控制器
 */
@interface E_WebViewControler : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *_selectString;

}

- (id)initWithSelectString:(NSString *)selectString;

@end
