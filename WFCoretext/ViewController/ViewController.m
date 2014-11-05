//
//  ViewController.m
//  WFCoretext
//
//  Created by 吴福虎 on 14/10/24.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "ViewController.h"
#import "WXViewController.h"

#import "DetailViewController.h"
#import "ContantHead.h"



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   
     NSMutableArray *_dataSourceArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArr = [[NSMutableArray alloc] init];
    [_dataSourceArr addObject:@"UIView"];
    [_dataSourceArr addObject:@"UITableView"];

    
    
    
    UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    mainTable.backgroundColor = [UIColor clearColor];
   // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
 
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [_dataSourceArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_dataSourceArr objectAtIndex:indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        DetailViewController *detailVc = [DetailViewController new];
        [self presentViewController:detailVc animated:YES completion:NULL];
    }else{
        WXViewController *wxVc = [WXViewController new];
        [self presentViewController:wxVc animated:YES completion:NULL];
    
    }

}





@end
