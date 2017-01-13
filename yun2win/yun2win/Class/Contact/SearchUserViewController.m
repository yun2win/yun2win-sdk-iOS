//
//  SearchUserViewController.m
//  API
//
//  Created by QS on 16/3/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SearchUserViewController.h"
#import "ProfileViewController.h"
#import "MemberModelCell.h"
#import "UserModel.h"

@interface SearchUserViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray<UserModel *> *users;

@end



@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.clearsOnBeginEditing = YES;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[MemberModelCell class] forCellReuseIdentifier:NSStringFromClass([MemberModelCell class])];
    
    self.users = [NSMutableArray array];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - ———— UITextFieldDelegate ———— -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self search];
    return YES;
}


#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberModelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberModelCell class])];
    
    cell.model = self.users[indexPath.row];
    
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.users[indexPath.row] rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Y2WUser *user = [self.users[indexPath.row] user];
    if (!user) {
        return;
    }
    ProfileViewController *userVC = [[ProfileViewController alloc] initWithUser:user];
    [self pushViewController:userVC];
}



#pragma mark - ———— Response ———— -

- (void)search {
    
    [[Y2WUsers getInstance].remote searchUserWithKey:self.textField.text success:^(NSArray *users) {
        [self.users removeAllObjects];
        
        for (Y2WUser *user in users) {
            UserModel *model = [[UserModel alloc] initWithUser:user];
            [self.users addObject:model];
        }
        [self.tableView reloadData];
        
        if (!self.users.count) {
            self.warningLabel.text = @"用户不存在";
        }
        self.warningLabel.hidden = self.users.count;
        self.tableView.hidden = !self.users.count;
        
    } failure:^(NSError *error) {
        [UIAlertView showTitle:nil message:error.message];
    }];
}

@end
