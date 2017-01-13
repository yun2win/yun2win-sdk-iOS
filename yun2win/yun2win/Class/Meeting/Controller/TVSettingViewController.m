//
//  TVSettingViewController.m
//  yunTV
//
//  Created by duanhl on 16/11/16.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "TVSettingViewController.h"
#import "MyTVModel.h"

@interface TVSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray     *dataArray;

@end

@implementation TVSettingViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kNavLeft;
    [self setupTableView];
    [self setupData];
}

//设置数据
- (void)setupData {
    [self.dataArray removeAllObjects];
    
//    NSMutableArray *group0 = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *group1 = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *group2 = [NSMutableArray arrayWithCapacity:0];
//    
//    NSArray *tempArray0 = @[@{@"title":@"名称", @"desc":@"218会议室"},
//                           @{@"title":@"ID", @"desc":@"9876776677"},
//                           @{@"title":@"WiFi", @"desc":@"liyueyun-1"}];
//    NSArray *tempArray1 = @[@{@"title":@"当前状态", @"desc":@"待机"}];
//    NSArray *tempArray2 = @[@{@"title":@"管理者", @"desc":@"张三"},
//                            @{@"title":@"连接密码", @"desc":@"有"}];
    
//    for (NSDictionary *dic in tempArray0) {
//        MyTVModel *model = [[MyTVModel alloc] init];
//        model.name = [dic objectForKey:@"title"];
//        model.status = [dic objectForKey:@"desc"];
//        
//        [group0 addObject:model];
//    }
//    
//    for (NSDictionary *dic in tempArray1) {
//        MyTVModel *model = [[MyTVModel alloc] init];
//        model.name = [dic objectForKey:@"title"];
//        model.status = [dic objectForKey:@"desc"];
//        
//        [group1 addObject:model];
//    }
//    
//    for (NSDictionary *dic in tempArray2) {
//        MyTVModel *model = [[MyTVModel alloc] init];
//        model.name = [dic objectForKey:@"title"];
//        model.status = [dic objectForKey:@"desc"];
//        
//        [group2 addObject:model];
//    }
//    
//    [self.dataArray addObject:group0];
//    [self.dataArray addObject:group1];
//    [self.dataArray addObject:group2];
    [self.tableView reloadData];
}

//设置tableView
- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //设置cell线的左偏移
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArray = [self.dataArray objectAtIndex:section];
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"TVSettingCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:67 / 255.0f green:210 / 255.0f blue:205 / 255.0f alpha:1.0f];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
//    MyTVModel *model = self.dataArray[indexPath.section][indexPath.row];
//    cell.textLabel.text = model.name;
//    cell.detailTextLabel.text = model.status;
//    
//    if ([model.name isEqualToString:@"ID"]) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }else {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section + 1 == self.dataArray.count) ? 1.2f : 30.0f;
}

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
