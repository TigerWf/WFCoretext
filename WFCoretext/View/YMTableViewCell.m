//
//  YMTableViewCell.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
// 2 3 2 2 2 3 1 3 2 1

#import "YMTableViewCell.h"

#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"

#define kImageTag 9999


@implementation YMTableViewCell
{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, TableHeader)];
        headerImage.backgroundColor = [UIColor clearColor];
        headerImage.image = [UIImage imageNamed:@"mao.jpg"];
        CALayer *layer = [headerImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:10.0];
        [layer setBorderWidth:1];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:headerImage];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20, 5, self.frame.size.width - 120, TableHeader/2)];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = @"迪恩·温彻斯特";
        nameLbl.font = [UIFont systemFontOfSize:15.0];
        nameLbl.textColor = [UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:nameLbl];

        
        
        UILabel *introLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 20, 5 + TableHeader/2 , self.frame.size.width - 120, TableHeader/2)];
        introLbl.numberOfLines = 1;
        introLbl.font = [UIFont systemFontOfSize:14.0];
        introLbl.textColor = [UIColor grayColor];
        introLbl.text = @"这个人很懒，什么都没有留下";
        [self.contentView addSubview:introLbl];
        
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        
         foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        
        replyImageView = [[UIImageView alloc] init];
      
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];

        _replyBtn = [YMButton buttonWithType:0];
        [_replyBtn setImage:[UIImage imageNamed:@"fw_r2_c2.png"] forState:0];
        [self.contentView addSubview:_replyBtn];
        
        
    }
    return self;
}

- (void)foldText{
   
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setYMViewWith:(YMTextData *)ymData{
    
    tempDate = ymData;
   
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];
    
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(offSet_X, 15 + TableHeader, self.frame.size.width - 2 * offSet_X, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataWF;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, 15 + TableHeader, self.frame.size.width - 2 * offSet_X, hhhh);
    
   [_ymShuoshuoArray addObject:textView];
    
//按钮
    foldBtn.frame = CGRectMake(offSet_X - 10, 15 + TableHeader + hhhh + 10 , 50, 20 );
    
    if (ymData.islessLimit) {
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    

    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        
        [foldBtn setTitle:@"收起" forState:0];
    }
    
//图片部分
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
        
    }
    
    [_imageArray removeAllObjects];
  
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20*(i%3 + 1) + 80*(i%3), TableHeader + 10 * ((i/3) + 1) + (i/3) *  ShowImage_H + hhhh + kDistance + (ymData.islessLimit?0:30), 80, ShowImage_H)];
            image.userInteractionEnabled = YES;
        
            YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [image addGestureRecognizer:tap];
            tap.appendArray = ymData.showImageArray;
            image.backgroundColor = [UIColor clearColor];
            image.tag = kImageTag + i;
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
            [self.contentView addSubview:image];
            [_imageArray addObject:image];
  
    }
    
//最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        YMTextView * ymTextView = (YMTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
          //  NSLog(@"here");
            
        }
       
    }
    
    [_ymTextArray removeAllObjects];
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - ShowImage_H - kDistance ;
    }
    
    float backView_Y = 0;
    float backView_H = 0;
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
       
        YMTextView *_ilcoreText = [[YMTextView alloc] initWithFrame:CGRectMake(offSet_X,TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30) + balanceHeight + kReplyBtnDistance, self.frame.size.width - offSet_X * 2, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader + 10 + ShowImage_H + (ShowImage_H + 10)*(scale_Y/3) + origin_Y + hhhh + kDistance + (ymData.islessLimit?0:30);
        }
        
        _ilcoreText.delegate = self;
      
        _ilcoreText.attributedData = [ymData.attributedData objectAtIndex:i];
        
        
        [_ilcoreText setOldString:[ymData.replyDataSource objectAtIndex:i] andNewString:[ymData.completionReplySource objectAtIndex:i]];
        [_ilcoreText fitToSuggestedHeight];
        [self.contentView addSubview:_ilcoreText];
        origin_Y += [_ilcoreText getSuggestedHeight] + 10 ;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count - 1)*10;
    
    replyImageView.frame = CGRectMake(offSet_X, backView_Y - 10 + balanceHeight + 5 + kReplyBtnDistance, self.frame.size.width - offSet_X * 2, backView_H + 20 - 8);//微调
    
    _replyBtn.frame = CGRectMake(self.frame.size.width - offSet_X - 40 + 6, replyImageView.frame.origin.y - 24, 40, 18);
}

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
   //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
   
}

- (void)clickWFCoretext:(NSString *)clickString{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });

}

#pragma mark - 点击时间
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{

    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];


}

@end
