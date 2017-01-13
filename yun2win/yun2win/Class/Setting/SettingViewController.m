//
//  SettingViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewUserCell.h"
#import "SettingTableViewCellModel.h"
#import "ProfileViewController.h"
#import "WebViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}



#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.data[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCellModel *model = self.data[indexPath.section][indexPath.row];
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(model.cellClass)];
    
    [cell relodData:model tableView:tableView];
    
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCellModel *model = self.data[indexPath.section][indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingTableViewCellModel *model = self.data[indexPath.section][indexPath.row];
    
    if ([self respondsToSelector:model.cellAction]) {
        [self y2w_performSelector:model.cellAction];
    }
}



#pragma mark - ———— Response ———— -

- (void)clickUserInfo {
    Y2WUser *user = [Y2WUsers getInstance].getCurrentUser;
    if (!user) {
        return;
    }
    ProfileViewController *userVC = [[ProfileViewController alloc] initWithUser:user];
    [self pushViewController:userVC];
}

- (void)clickAbout {
    WebViewController *webVC = [[WebViewController alloc] initWithUrl:@"http://m.yun2win.icoc.in/col.jsp?id=112"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickHelp {
    WebViewController *webVC = [[WebViewController alloc] initWithUrl:@"http://www.yun2win8.icoc.me/"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickLogout {
    [[Y2WUsers getInstance].getCurrentUser.bridge logoutWithMessage:nil];
}



- (void)reloadData {
    NSMutableArray *sectons = [NSMutableArray array];
    
    Y2WCurrentUser *user = [Y2WUsers getInstance].getCurrentUser;
    
    SettingTableViewCellModel *userInfo = [[SettingTableViewCellModel alloc] init];
    userInfo.title = user.name;
    userInfo.detailTitle = [NSString stringWithFormat:@"账号 :  %@",user.email];
    userInfo.uid = user.ID;
    userInfo.avatarUrl = user.avatarUrl;
    userInfo.image = [UIImage y2w_imageNamed:@"默认个人头像"];
    userInfo.cellClass = [SettingTableViewUserCell class];
    userInfo.cellAction = @selector(clickUserInfo);
    userInfo.rowHeight = 80;
    userInfo.showAccessory = YES;
    [sectons addObject:@[userInfo]];
    
    SettingTableViewCellModel *about = [[SettingTableViewCellModel alloc] init];
    about.title = @"关于";
    about.cellClass = [SettingTableViewCell class];
    about.cellAction = @selector(clickAbout);
    about.rowHeight = 50;
    about.showAccessory = YES;
    [sectons addObject:@[about]];
    
    SettingTableViewCellModel *logout = [[SettingTableViewCellModel alloc] init];
    logout.title = @"退出";
    logout.cellClass = [SettingTableViewCell class];
    logout.cellAction = @selector(clickLogout);
    logout.rowHeight = 50;
    logout.showAccessory = NO;
    [sectons addObject:@[logout]];

    self.data = sectons;

    [self.tableView reloadData];
}



#pragma mark - ———— getter ———— -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"DAEBEB"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionHeaderHeight = 20;
        _tableView.sectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SettingTableViewCell class])];
        [_tableView registerClass:[SettingTableViewUserCell class] forCellReuseIdentifier:NSStringFromClass([SettingTableViewUserCell class])];
    }
    return _tableView;
}

@end
