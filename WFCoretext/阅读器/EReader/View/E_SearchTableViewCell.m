//
//  E_SearchTableViewCell.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SearchTableViewCell.h"
#import "E_ContantFile.h"

@implementation E_SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor grayColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, kScreenW - 40, 24)];
        _contentLbl.textColor = [UIColor blackColor];
        _contentLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _contentLbl.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_contentLbl];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
