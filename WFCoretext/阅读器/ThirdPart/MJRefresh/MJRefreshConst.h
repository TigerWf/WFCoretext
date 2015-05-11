//
//  MJRefreshConst.h
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define MJRefreshLabelTextColor MJColor(150, 150, 150)

#define MJRefreshViewHeight  64.0
#define MJRefreshFastAnimationDuration  0.25
#define MJRefreshSlowAnimationDuration  0.4

#define MJRefreshBundleName  @"MJRefresh.bundle"

#define MJRefreshFooterPullToRefresh  @"上拉刷新"
#define MJRefreshFooterReleaseToRefresh  @"松开刷新"
#define MJRefreshFooterRefreshing  @"刷新中"

#define MJRefreshHeaderPullToRefresh  @"下拉刷新"
#define MJRefreshHeaderReleaseToRefresh  @"松开刷新"
#define MJRefreshHeaderRefreshing  @"刷新中"
#define MJRefreshHeaderTimeKey  @"MJRefreshHeaderView"

#define MJRefreshContentOffset  @"contentOffset"
#define MJRefreshContentSize  @"contentSize"