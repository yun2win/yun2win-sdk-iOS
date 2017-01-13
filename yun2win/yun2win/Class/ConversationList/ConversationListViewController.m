    //
//  ConversationListViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "Y2WUserConversations.h"
#import "ConversationListCell.h"
#import "MainViewController.h"
#import "Y2WSearchController.h"
#import "SearchUserViewController.h"
#import "PopoverView.h"

@interface ConversationListViewController () <UITableViewDataSource,UITableViewDelegate,Y2WUserConversationsDelegate,UISearchBarDelegate>

@property (nonatomic, retain) Y2WUserConversations *userConversations;

@property (nonatomic, retain) Y2WSearchController *searchController;

@property (nonatomic, retain) UITableView *tableView;

@end


@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage y2w_imageNamed:@"导航栏_加号"] forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:self action:@selector(navRightBut:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.view addSubview:self.tableView];
    [self.userConversations addDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}



#pragma mark - ———— Y2WUserConversationsDelegate ———— -

- (void)userConversationsWillChangeContent:(Y2WUserConversations *)userConversations {
    [self.tableView beginUpdates];
}

- (void)userConversations:(Y2WUserConversations *)userConversations didDeleteIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)userConversations:(Y2WUserConversations *)userConversations didInsertIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)userConversations:(Y2WUserConversations *)userConversations didReloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations {
    [self.tableView endUpdates];
}



#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.backgroundView.hidden = self.userConversations.getUserConversations.count;
    return self.userConversations.getUserConversations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConversationListCell class])];
    cell.conversation = self.userConversations.getUserConversations[indexPath.row];
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Y2WUserConversation *conversation = self.userConversations.getUserConversations[indexPath.row];
    [self pushToSessionWithConversation:conversation];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    Y2WUserConversation *conversation = self.userConversations.getUserConversations[indexPath.row];

    UITableViewRowAction *deleteAction = [self deleteUserConversation];
    UITableViewRowAction *topAction = [self setTopWithUserConversation:conversation];
    return @[deleteAction,topAction];
}








#pragma mark - ———— Response ———— -

- (void)pushToSessionWithConversation:(Y2WUserConversation *)conversation {
    [self.navigationItem startAnimating];
    [conversation getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
        
        [self.navigationItem stopAnimating];
        if (error) {
            [UIAlertView showTitle:nil message:error.message];
            return;
        }
        
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        [self pushViewController:conversationVC];
    }];
}

- (UITableViewRowAction *)deleteUserConversation {
    return [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.navigationItem startAnimating];
        
        Y2WUserConversation *conversation = self.userConversations.getUserConversations[indexPath.row];
        [conversation.userConversations.remote deleteUserConversation:conversation success:^{
            
            [self.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:error.message];
        }];
    }];
}

- (UITableViewRowAction *)setTopWithUserConversation:(Y2WUserConversation *)conversation {
    NSString *title = conversation.top ? @"取消置顶":@"置顶";

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.navigationItem startAnimating];
        conversation.top = !conversation.top;

        [conversation.userConversations.remote updateUserConversation:conversation success:^{
            
            [self.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:error.message];
        }];
    }];
    
    action.backgroundColor = [UIColor blueColor];
    return action;
}







#pragma mark - ———— getter ———— -

- (Y2WUserConversations *)userConversations {
    if (!_userConversations) {
        _userConversations = [Y2WUsers getInstance].getCurrentUser.userConversations;
    }
    return _userConversations;
}

- (Y2WSearchController *)searchController {
    if (!_searchController) {
        _searchController = [[Y2WSearchController alloc] init];
    }
    return _searchController;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage y2w_imageNamed:@"默认图-会话"]];
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        [_tableView registerClass:[ConversationListCell class] forCellReuseIdentifier:NSStringFromClass([ConversationListCell class])];
    }
    return _tableView;
}

//发起群聊
- (void)createSession {
    
    ContactPickerConfig *config = [[ContactPickerConfig alloc] init];
    config.filterIds = @[[Y2WUsers getInstance].currentUser.ID];
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {
        [self createSessionWith:members];
    } cancel:nil];
    
    [self pushViewController:userPickerVC];
}

- (void)createSessionWith:(NSArray<NSObject<MemberModelInterface> *> *)members {
    [self.navigationItem startAnimating];
    
    [[Y2WUsers getInstance].getCurrentUser.contacts.user.sessions.remote addWithName:nil type:@"group" secureType:@"public" avatarUrl:nil success:^(Y2WSession *session) {
        // 创建成功准备添加成员
        // 构建需要添加的成员对象
        NSMutableArray *sessionMembers = [NSMutableArray array];
        for (NSObject<MemberModelInterface> *member in members) {
            
            Y2WSessionMember *sessionMember = [[Y2WSessionMember alloc] init];
            sessionMember.name = member.name;
            sessionMember.userId = member.uid;
            sessionMember.avatarUrl = member.imageUrl;
            sessionMember.role = @"user";
            sessionMember.status = @"active";
            [sessionMembers addObject:sessionMember];
        }
        
        __weak typeof(session) weakSession = session;
        // 添加成员
        [session.members.remote addSessionMembers:sessionMembers success:^{
            __strong typeof(session) strongSession = weakSession;
            
            [self.navigationItem stopAnimating];
            ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:strongSession];
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        } failure:^(NSError *error) {
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:error.message];
        }];
        
    } failure:^(NSError *error) {
        [self.navigationItem startAnimating];
        [UIAlertView showTitle:nil message:error.message];
    }];
}


//导航右按钮
- (void)navRightBut:(UIButton *)sender
{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2 - 15.0f, sender.frame.origin.y + sender.frame.size.height + 25.0f);
    NSDictionary *dic = @{@"添加好友":[SearchUserViewController class],
                          @"发起群聊":[UserPickerViewController class]};
    NSArray *titles = @[@"添加好友", @"发起群聊"];
    NSArray *images = @[@"添加好友_", @"发起群聊_"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:images];
    pop.selectRowAtIndex = ^(NSInteger index){
       if ([[titles objectAtIndex:index] isEqualToString:@"发起群聊"]){
            [self createSession];
        }else {
            Class targetVc = [dic objectForKey:titles[index]];
            UIViewController *controller = [[targetVc alloc] init];
            controller.title = [titles objectAtIndex:index];
            [self.navigationController pushViewController:controller animated:YES];
        }
    };
    
    [pop show];
}

- (void)dealloc
{
    [self.userConversations removeDelegate:self];
}

@end
