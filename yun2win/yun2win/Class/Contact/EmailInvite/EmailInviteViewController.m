//
//  EmailInviteViewController.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "EmailInviteViewController.h"
#import "EmailInviteCell.h"

@interface EmailInviteViewController ()<UITableViewDelegate,UITableViewDataSource,Y2WSessionMembersDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) Y2WSessionMembers *members;

@property (nonatomic, retain) NSArray *invitingMembers;

@end

@implementation EmailInviteViewController

- (void)dealloc {
    [self.members removeDelegate:self];
}

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members {
    if (self = [super init]) {
        self.members = members;
        self.title = @"邮件邀请";
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.returnKeyType = UIReturnKeyDone;
    [self.searchBar setImage:[UIImage imageWithUIColor:[UIColor clearColor]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    if ([self.searchBar respondsToSelector:NSSelectorFromString(@"searchField")]) {
        UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
        searchField.layer.cornerRadius = 14;
        searchField.layer.borderWidth = 0.5;
        searchField.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    }
    if ([self.searchBar respondsToSelector:NSSelectorFromString(@"cancelButton")]) {
        UIButton *cancelButton = [self.searchBar valueForKey:@"cancelButton"];
        [cancelButton setBackgroundImage:[UIImage imageWithUIColor:[UIColor y2w_mainColor]] forState:UIControlStateNormal];
        [cancelButton setTitle:@"邀请" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        cancelButton.layer.cornerRadius = 5;
        cancelButton.clipsToBounds = YES;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmailInviteCell" bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([EmailInviteCell class])];
    
    [self reloadData];
    [self.members addDelegate:self];
}

- (void)reloadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableArray *invitingMembers = [NSMutableArray array];
        for (Y2WSessionMember *member in self.members.getAllMembers) {
            if (member.time) {
                [invitingMembers addObject:member];
            }
        }
        self.invitingMembers = [invitingMembers sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"userId"ascending:YES]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)inviteWithEmail:(NSString *)email {
    [self.navigationItem startAnimating];
    [self.members.remote inviteSessionMemberWithEmail:email success:^{
        [self.navigationItem stopAnimating];
        [self reloadData];
        [UIAlertView showTitle:nil message:@"邀请邮件发送成功"];
        
    } failure:^(NSError *error) {
        [self.navigationItem stopAnimating];
        [UIAlertView showTitle:nil message:error.message];
    }];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - ———— UISearchBarDelegate ———— -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self inviteWithEmail:searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - ———— Y2WSessionMembersDelegate ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invitingMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmailInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmailInviteCell class])];
    Y2WSessionMember *member = self.invitingMembers[indexPath.row];
    [cell setMember:member handler:^{
        [self inviteWithEmail:member.userId];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
}


#pragma mark - ———— Y2WSessionMembersDelegate ———— -

- (void)sessionMembersDidChangeContent:(Y2WSessionMembers *)sessionMembers {
    [self reloadData];
}

@end
