//
//  E_SearchViewController.m
//  WFReader
//
//  Created by 阿虎 on 15/2/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_SearchViewController.h"
#import "E_CommonManager.h"
#import "E_ReaderDataSource.h"
#import "E_SearchTableViewCell.h"
@interface E_SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    UITextField    *_searchTextField;
    UITableView    *_searchResultView;
    BOOL            _isFirstTime;
    NSMutableArray *_dataSource;
    BOOL            _isSearch;
    NSString       *_keyWord;
}
@end

@implementation E_SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _isFirstTime = YES;
    _isSearch = NO;
    UIImage *_themeImage = nil;
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    if (themeID == 1) {
        _themeImage = nil;
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:_themeImage];
    }
    
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 72)];
    navView.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [self.view addSubview:navView];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(self.view.frame.size.width - 60, 20, 60, 44);
    [backBtn setTitle:@"取消" forState:0];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitleColor:[UIColor whiteColor] forState:0];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
   
    UIImageView *textFieldBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, self.view.frame.size.width - 75, 36)];
    textFieldBg.layer.cornerRadius = 3;
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [textFieldBg.layer setBorderWidth:1.0];
    textFieldBg.userInteractionEnabled = YES;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 230/255.0, 230/255.0, 230/255.0, 1 });
    [textFieldBg.layer setBorderColor:colorref];
    [self.view addSubview:textFieldBg];
    CGColorSpaceRelease(colorSpace);

    UIImageView *fangdajingBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 13, 13)];
    fangdajingBg.image = [UIImage imageNamed:@"magnifiter.png"];
    [textFieldBg addSubview:fangdajingBg];
    
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(45,28,textFieldBg.frame.size.width-30,32)];
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"输入一个关键词";
    [self.view addSubview:_searchTextField];
    
    _searchResultView = [[UITableView alloc] initWithFrame:CGRectMake(0, navView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navView.frame.size.height)];
    _searchResultView.delegate = self;
    _searchResultView.dataSource = self;
    _searchResultView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_searchResultView];
    [_searchResultView addFooterWithTarget:self action:@selector(loadMoreInfo)];
    _searchResultView.hidden = YES;
    
}

- (void)loadMoreInfo{

    [_searchResultView footerEndRefreshing];
     NSMutableArray *tempArray = [[E_ReaderDataSource shareInstance] searchWithKeyWords:_searchTextField.text];
   
    [[_dataSource objectAtIndex:0] addObjectsFromArray:[tempArray objectAtIndex:0]];
    [[_dataSource objectAtIndex:1] addObjectsFromArray:[tempArray objectAtIndex:1]];
    [[_dataSource objectAtIndex:2] addObjectsFromArray:[tempArray objectAtIndex:2]];
    [_searchResultView reloadData];
  
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    [[E_ReaderDataSource shareInstance] resetTotalString];
  
    [_dataSource removeAllObjects];
    NSMutableArray *tempArray = [[E_ReaderDataSource shareInstance] searchWithKeyWords:textField.text];
    _keyWord = textField.text;
    [_dataSource addObject:[tempArray objectAtIndex:0]];
    [_dataSource addObject:[tempArray objectAtIndex:1]];
    [_dataSource addObject:[tempArray objectAtIndex:2]];
    
    [_searchTextField resignFirstResponder];
    _isSearch = YES;
    _searchResultView.hidden = NO;
    [_searchResultView reloadData];
    return YES;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isSearch == NO) {
        return 0;
    }else{
        return [[_dataSource objectAtIndex:0] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"listCell";
    E_SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (cell == nil) {
        cell = [[E_SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.chapterLbl.text = [NSString stringWithFormat:@"第%@章",[[_dataSource objectAtIndex:1] objectAtIndex:indexPath.row]];
    
    //寻找并变色
    NSMutableString *attString = [NSMutableString stringWithString:[[_dataSource objectAtIndex:0] objectAtIndex:indexPath.row]];
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < _searchTextField.text.length; i ++) {
        
        [blankWord appendString:@" "];
    }
    for (int i = 0; i < INT_MAX; i++) {
        
        if ([attString rangeOfString:_searchTextField.text options:1].location != NSNotFound){
            NSInteger newLo = [attString rangeOfString:_searchTextField.text  options:1].location;
            NSInteger newLen = [attString rangeOfString:_searchTextField.text  options:1].length;
            NSRange newRange = NSMakeRange(newLo, newLen);
            [rangeArray addObject:NSStringFromRange(newRange)];
            [attString replaceCharactersInRange:newRange withString:blankWord];
        
        }else{
        
            break;
        }
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[_dataSource objectAtIndex:0] objectAtIndex:indexPath.row]];
    for (int i = 0; i < rangeArray.count; i ++) {
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSRangeFromString([rangeArray objectAtIndex:i])];
    }
    cell.contentLbl.attributedText = str;
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [_delegate turnToClickSearchResult:[[_dataSource objectAtIndex:1] objectAtIndex:indexPath.row] withRange:NSRangeFromString([[_dataSource objectAtIndex:2] objectAtIndex:indexPath.row]) andKeyWord:_keyWord];
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)backToFront{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [_searchTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
