//
//  E_SearchViewController.h
//  WFReader
//
//  Created by 吴福虎 on 15/2/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+MJRefresh.h"

/**
 *  搜索页面
 */
@protocol E_SearchViewControllerDelegate <NSObject>

- (void)turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord;

@end

@interface E_SearchViewController : UIViewController

@property(nonatomic,assign)id<E_SearchViewControllerDelegate>delegate;

@end
