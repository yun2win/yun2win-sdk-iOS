//
//  TVInfoViewController.m
//  yun2win
//
//  Created by duanhl on 16/11/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "TVInfoViewController.h"

@interface TVInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray     *dataArray;

@end

@implementation TVInfoViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }

    return _dataArray;
}

//设置数据
- (void)setupData {
    [self.dataArray removeAllObjects];
//    [self.TVContact getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
//        NSDictionary *dic = session.extend;
//        
//        
//        NSArray *tempArray = @[@{@"title":@"品牌", @"desc":self.model.brand},
//                             @{@"title":@"型号", @"desc":self.model.model},
//                             @{@"title":@"状态", @"desc":self.model.state}];
//    
//        [self.dataArray addObjectsFromArray:tempArray];
//        [self.tableView reloadData];
//    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    kNavLeft;
    [self setupData];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"TVInfoCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:67 / 255.0f green:210 / 255.0f blue:205 / 255.0f alpha:1.0f];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    NSString *stateStr = nil;
    if ([[dic objectForKey:@"desc"] intValue] == 0) {
        stateStr = @"闲";
    }else{
        stateStr = @"忙";
    }
    
    cell.detailTextLabel.text = stateStr;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
