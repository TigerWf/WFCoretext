//
//  WXViewController.m
//  WFCoretext
//
//  Created by 吴福虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMTextData.h"

#define dataCount 8
#define kLocationToBottom 20

@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_imageDataSource;
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    UITableView *mainTable;
}
@end

@implementation WXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:@"我是返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
   
    //
    _tableDataSource = [[NSMutableArray alloc] init];
    
    _contentDataSource = [[NSMutableArray alloc]init];
    [_contentDataSource addObject:kContentText1];
    [_contentDataSource addObject:kContentText2];
    [_contentDataSource addObject:kContentText3];
    [_contentDataSource addObject:kContentText4];
    [_contentDataSource addObject:kContentText5];
    [_contentDataSource addObject:kContentText6];
    
    [self initTableview];
    [self configData];
    [self loadReplyData];
}

- (void)loadReplyData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray=[[NSMutableArray alloc]init];
         
         for (int i = 0 ; i < dataCount; i ++) {
             
             NSMutableArray * array=[[NSMutableArray alloc]init];
             [array addObject:[_contentDataSource objectAtIndex:arc4random() % 6]];
             [array addObject:[_contentDataSource objectAtIndex:arc4random() % 6]];
             [array addObject:[_contentDataSource objectAtIndex:arc4random() % 6]];
             
             YMTextData *ymData = [[YMTextData alloc] init];
             ymData.replyDataSource = array;
             [ymDataArray addObject:ymData];
             
         }
         [self calculateHeight:ymDataArray];
     });


}

- (void)calculateHeight:(NSMutableArray *)dataArray{

    
    for (YMTextData *ymData in dataArray) {
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource addObject:ymData];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
               [mainTable reloadData];
      
    });

   
}


- (void)configData{
   
    _imageDataSource = [NSMutableArray arrayWithCapacity:0];
    [_imageDataSource addObject:@"我是图片1"];
    [_imageDataSource addObject:@"我是图片2"];
    [_imageDataSource addObject:@"我是图片3"];
}

- (void)backToPre{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initTableview{

    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];

}

//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 30 + 40 + kLocationToBottom + ((YMTextData *)[_tableDataSource objectAtIndex:indexPath.row]).replyHeight;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    [cell setShowImage:_imageDataSource];
    [cell setYMTextViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    
    
    
    return cell;
}


@end
