//
//  E_ListView.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/15.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_ListView.h"
#import "E_ReaderDataSource.h"
#import "E_MarkTableViewCell.h"


@implementation E_ListView

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:234/255.0 alpha:1.0];
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        dataCount = [E_ReaderDataSource shareInstance].totalChapter;
        [self configListView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEListView:)];
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

- (void)panEListView:(UIPanGestureRecognizer *)recongnizer{
    CGPoint touchPoint = [recongnizer locationInView:self];
    switch (recongnizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartX = touchPoint.x;
           }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGFloat offSetX = touchPoint.x - _panStartX;
            CGRect newFrame = self.frame;
            //NSLog(@"offSetX == %f",offSetX);
            newFrame.origin.x += offSetX;
            if (newFrame.origin.x >= 0){//试图向上滑动 阻止
               
                newFrame.origin.x = 0;
                self.frame = newFrame;
                return;
            }else{
                self.frame = newFrame;
            }
            
        
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            float duringTime = (self.frame.size.width + self.frame.origin.x)/self.frame.size.width * 0.25;
            if (self.frame.origin.x < 0) {
                [UIView animateWithDuration:duringTime animations:^{
                    self.frame = CGRectMake(-self.frame.size.width , 0,  self.frame.size.width, self.frame.size.height);
                } completion:^(BOOL finished) {
                    [_delegate removeE_ListView];
                }];
                
            }
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        default:
            break;
    }


}



- (void)configListView{
    
    _isMenu = YES;
    _isMark = NO;
    _isNote = NO;
    
    [self configListViewHeader];
   
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height - 80 - 60)];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor clearColor];
    [self addSubview:_listView];
    
    UIButton *otherBtn = [UIButton buttonWithType:0];
    otherBtn.frame = CGRectMake(70, self.frame.size.height - 40, self.frame.size.width - 140, 20);
    otherBtn.layer.borderWidth = 1.0;
    otherBtn.layer.cornerRadius = 2.0;
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherBtn setTitleColor:[UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] forState:0];
    [otherBtn setTitle:@"备用按钮" forState:0];
    otherBtn.layer.borderColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0].CGColor;
    [self addSubview:otherBtn];
    
}

- (void)configListViewHeader{

    NSArray *segmentedArray = @[@"目录",@"书签"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentControl.frame = CGRectMake(15, 30, self.bounds.size.width - 30 , 40);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.tintColor = [UIColor colorWithRed:233/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    [self addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:dict forState:0];

}

- (void)segmentAction:(UISegmentedControl *)sender{
    
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:{
                _isMenu = YES;
                _isMark = NO;
                _isNote = NO;
                dataCount = [E_ReaderDataSource shareInstance].totalChapter;
                [_listView reloadData];
            }
            break;
        case 1:{
                _isMenu = NO;
                _isMark = YES;
                _isNote = NO;
                _dataSource = [E_CommonManager Manager_getMark];
                [_listView reloadData];
            }
            break;
//        case 2:{
//                _isMenu = NO;
//                _isMark = NO;
//                _isNote = YES;
//        
//            }
//            
//            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (_isMark) {
        return 100;
    }
    
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isMark) {
        return _dataSource.count;
    }
    return dataCount;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMark) {
        [_delegate clickMark:[_dataSource objectAtIndex:indexPath.row]];
        return;
    }
    
    [_delegate clickChapter:indexPath.row];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isMenu == YES) {
        static NSString *cellStr = @"menuCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
        return cell;

    }else if(_isMark){
        
        static NSString *cellStr = @"markCell";
        E_MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[E_MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.chapterLbl.text = [NSString stringWithFormat:@"第%@章",[(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markChapter]];
        cell.timeLbl.text    = [(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markTime];
        cell.contentLbl.text = [(E_Mark *)[_dataSource objectAtIndex:indexPath.row] markContent];
        return cell;
    
    }else{
        static NSString *cellStr = @"noteCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row + 1];
        return cell;
        
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
