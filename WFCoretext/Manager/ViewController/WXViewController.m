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
    
    UIButton *replyBtn;
    
    YMReplyInputView *replyView ;
    
    
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
    
    _contentDataSource = [[NSMutableArray alloc] init];//回复数据来源
    [_contentDataSource addObject:kContentText1];
    [_contentDataSource addObject:kContentText2];
    [_contentDataSource addObject:kContentText3];
    [_contentDataSource addObject:kContentText4];
    [_contentDataSource addObject:kContentText5];
    [_contentDataSource addObject:kContentText6];
    
    _shuoshuoDatasSource = [[NSMutableArray alloc] init];//说说数据来源
    
    [_shuoshuoDatasSource addObject:kShuoshuoText1];
    [_shuoshuoDatasSource addObject:kShuoshuoText2];
    [_shuoshuoDatasSource addObject:kShuoshuoText3];
    [_shuoshuoDatasSource addObject:kShuoshuoText4];
    [_shuoshuoDatasSource addObject:kShuoshuoText5];
    [_shuoshuoDatasSource addObject:kShuoshuoText6];
    
    
    
    [self initTableview];
    [self configImageData];
    [self loadTextData];
}

#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray=[[NSMutableArray alloc]init];
       
      
         
         for (int i = 0 ; i < dataCount; i ++) {
             
         //模拟数据 随机3组回复 以及图片
             NSMutableArray * array = [[NSMutableArray alloc]init];
             NSMutableArray * userDefineAttriArray = [[NSMutableArray alloc]init];
             int randomReplyCount = arc4random() % 6 + 1;
             for (int k = 0; k < randomReplyCount; k ++) {
                 [array addObject:[_contentDataSource objectAtIndex:arc4random() % 6]];
                 NSMutableArray *tempDefineArr = [[NSMutableArray alloc]init];
                 NSString *range = NSStringFromRange(NSMakeRange(0, 2));
                 
                 [tempDefineArr addObject:range];
                 [userDefineAttriArray addObject:tempDefineArr];
             }
             
             
             NSMutableArray * imageArray = [[NSMutableArray alloc] init];
             int randomImageCount = arc4random() % 9 + 1;
             
             for (int j = 0; j < randomImageCount; j ++) {
                 
                [imageArray addObject:[_imageDataSource objectAtIndex:arc4random() % 9]];
             }
            
        //图片上面说说部分
             NSString *aboveString = [_shuoshuoDatasSource objectAtIndex:arc4random() % 6];
             
             YMTextData *ymData = [[YMTextData alloc] init];
             ymData.showImageArray = imageArray;
             ymData.foldOrNot = YES;
             ymData.showShuoShuo = aboveString;
             ymData.defineAttrData = userDefineAttriArray;
             ymData.replyDataSource = array;
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

#pragma mark - 图片数据源
- (void)configImageData{
   
    _imageDataSource = [NSMutableArray arrayWithCapacity:0];
    [_imageDataSource addObject:@"1.png"];
    [_imageDataSource addObject:@"2.png"];
    [_imageDataSource addObject:@"3.png"];
    [_imageDataSource addObject:@"1.png"];
    [_imageDataSource addObject:@"2.png"];
    [_imageDataSource addObject:@"3.png"];
    [_imageDataSource addObject:@"1.png"];
    [_imageDataSource addObject:@"2.png"];
    [_imageDataSource addObject:@"3.png"];
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
    cell.replyBtn.tag = indexPath.row;
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
    
        replyBtn = [UIButton buttonWithType:0];
        replyBtn.layer.cornerRadius = 5;
        replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:1.0];
        replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 10 , 0, 38);
        [replyBtn setTitleColor:[UIColor whiteColor] forState:0];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        replyBtn.tag = sender.tag;
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
- (void)replyMessage:(UIButton *)sender{
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
    
    NSString *newString = [NSString stringWithFormat:@"%@:%@",kAdmin,replyText];//此处可扩展。已写死，包括内部逻辑也写死 在YMTextData里 自行添加部分
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
    [ymData.replyDataSource addObject:newString];
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedData removeAllObjects];
    
    NSString *rangeStr = NSStringFromRange(NSMakeRange(0, kAdmin.length));
    NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
    [rangeArr addObject:rangeStr];
    [ymData.defineAttrData addObject:rangeArr];
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
