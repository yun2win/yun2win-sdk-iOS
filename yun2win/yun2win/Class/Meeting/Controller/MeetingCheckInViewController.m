//
//  MeetingCheckInViewController.m
//  yunTV
//
//  Created by duanhl on 16/11/16.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "MeetingCheckInViewController.h"
#import "MeetingCheckCell.h"
#import "MeetingCheckModel.h"

#define KMeetingCheckCellId @"KMeetingCheckCellId"

@interface MeetingCheckInViewController ()<UITableViewDelegate, UITableViewDataSource, MeetingCheckDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray     *dataArray;

@end

@implementation MeetingCheckInViewController

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
    self.NavRightImage = @"导航栏_加号";
    [self setupTableView];
    [self setupData];
}

//设置数据
- (void)setupData {
    MeetingCheckModel *model = [[MeetingCheckModel alloc] init];
    model.name = @"王五";
    model.isCheck = @YES;
    MeetingCheckModel *model2 = [[MeetingCheckModel alloc] init];
    model2.name = @"赵六";
    model2.isCheck = @NO;
    
    [self.dataArray addObject:model];
    [self.dataArray addObject:model2];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}

//设置tableView
- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MeetingCheckCell" bundle:nil] forCellReuseIdentifier:KMeetingCheckCellId];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MeetingCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:KMeetingCheckCellId];
    cell.delegate = self;
    if (self.dataArray.count > 0 && self.dataArray.count > indexPath.row) {
        MeetingCheckModel *model = self.dataArray[indexPath.row];
        [cell setupData:model];
    }
    
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
    
    return kMeetingCheckCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark MeetingCheckDelegate
- (void)meetingCheckCell:(MeetingCheckCell *)cell {
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    if (self.dataArray.count > index.row) {
        MeetingCheckModel *model = [self.dataArray objectAtIndex:index.row];
        model.isCheck = [NSNumber numberWithBool:!model.isCheck.boolValue];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
