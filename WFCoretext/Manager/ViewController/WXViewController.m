//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin @"小虎-tiger"


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    UITableView *mainTable;
    
    YMButton *replyBtn;
    
    YMReplyInputView *replyView ;
    
    
}
@end

@implementation WXViewController


#pragma mark - 数据源
- (void)configData{
    
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    
    WFReplyBody *body1 = [[WFReplyBody alloc] init];
    body1.replyUser = @"山姆";
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    
    
    WFReplyBody *body2 = [[WFReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
   
    
    WFReplyBody *body3 = [[WFReplyBody alloc] init];
    body3.replyUser = @"山姆";
    body3.repliedUser = @"";
    body3.replyInfo = kContentText3;
   
    
    WFReplyBody *body4 = [[WFReplyBody alloc] init];
    body4.replyUser = @"雷锋";
    body4.repliedUser = @"简森·阿克斯";
    body4.replyInfo = kContentText4;
    
    
    WFReplyBody *body5 = [[WFReplyBody alloc] init];
    body5.replyUser = kAdmin;
    body5.repliedUser = @"";
    body5.replyInfo = kContentText5;
    
    
    WFReplyBody *body6 = [[WFReplyBody alloc] init];
    body6.replyUser = @"红领巾";
    body6.repliedUser = @"";
    body6.replyInfo = kContentText6;
    
    
    WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[@"1.png",@"2.png",@"3.png"];
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    
    
    WFMessageBody *messBody2 = [[WFMessageBody alloc] init];
    messBody2.posterContent = kShuoshuoText2;
    messBody2.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"3.png",@"2.png",@"1.png",@"2.png",@"1.png",@"3.png"];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body3,body6, nil];
    
    
    WFMessageBody *messBody3 = [[WFMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText3;
    messBody3.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"2.png",@"1.png",@"3.png"];
    messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body6,body5,body4, nil];
    
    
    WFMessageBody *messBody4 = [[WFMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText4;
    messBody4.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"1.png",@"3.png"];
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body5, nil];
    
    
    WFMessageBody *messBody5 = [[WFMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText5;
    messBody5.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"3.png"];
    messBody5.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5, nil];
    
    WFMessageBody *messBody6 = [[WFMessageBody alloc] init];
    messBody6.posterContent = kShuoshuoText5;
    messBody6.posterPostImage = @[@"1.png",@"2.png",@"3.png",@"3.png",@"2.png"];
    messBody6.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5,body4,body6, nil];

    
    
    [_contentDataSource addObject:messBody1];
    [_contentDataSource addObject:messBody2];
    [_contentDataSource addObject:messBody3];
    [_contentDataSource addObject:messBody4];
    [_contentDataSource addObject:messBody5];
    [_contentDataSource addObject:messBody6];
 
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:@"我是返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
   
    [self configData];
    
    [self initTableview];
    
    [self loadTextData];
}

#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
       
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
             
             WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
             YMTextData *ymData = [[YMTextData alloc] init ];
             ymData.messageBody = messBody;
            
             [ymDataArray addObject:ymData];
             
         }
         [self calculateHeight:ymDataArray];
         
    });
}



#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{

    
   // NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
        
    }
    
//    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
  //  NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
               [mainTable reloadData];
      
    });

   
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
   
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
   // cell.replyBtn.tag = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];

    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
     
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    float origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
  
    if (replyBtn) {
        
        [UIView animateWithDuration:0.25f animations:^{
            
            replyBtn.frame = CGRectMake(sender.frame.origin.x, origin_Y - 10 , 0, 38);
        } completion:^(BOOL finished) {
            NSLog(@"销毁");
            [replyBtn removeFromSuperview];
            replyBtn = nil;
            
        }];

        
       
    }else{
    
        replyBtn = [YMButton buttonWithType:0];
        replyBtn.layer.cornerRadius = 5;
        replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:1.0];
        replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 10 , 0, 38);
        [replyBtn setTitleColor:[UIColor whiteColor] forState:0];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        replyBtn.tag = sender.appendIndexPath.row;
        [mainTable addSubview:replyBtn];
        [replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIView animateWithDuration:0.25f animations:^{
                replyBtn.frame = CGRectMake(sender.frame.origin.x - 60, origin_Y  - 10 , 60, 38);
        } completion:^(BOOL finished) {
            [replyBtn setTitle:@"评论" forState:0];
        }];
    
    }
    


}

#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    //NSLog(@"TAG === %d",sender.tag);
    
    if (replyBtn){
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }
   // NSLog(@"alloc reply");
        
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = sender.tag;
    [self.view addSubview:replyView];


}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (replyBtn) {
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }

}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];

}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
   
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
       
    }];

}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    NSLog(@"inputTag === %zi",inputTag);
    WFReplyBody *body = [[WFReplyBody alloc] init];
    body.replyUser = kAdmin;
    body.repliedUser = @"";
    body.replyInfo = replyText;
    
   
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
    WFMessageBody *m = ymData.messageBody;
    [m.posterReplies addObject:body];
    
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    

    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
    
}

- (void)destorySelf{
    
  //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;

}


- (void)dealloc{
    
 

}

@end
