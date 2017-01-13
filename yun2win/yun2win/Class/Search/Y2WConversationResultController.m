//
//  Y2WConversationResultController.m
//  API
//
//  Created by QS on 16/8/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WConversationResultController.h"
#import "ConversationViewController.h"
#import "ConversationListCell.h"
#import "ServiceSearchModel.h"
#import "MBProgressHUD.h"


@interface Y2WConversationResultController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString       *searchStr;
@property (nonatomic, retain) dispatch_queue_t queue;

@property (strong, nonatomic) MBProgressHUD      *progressHUD;          //提示框

@end

@implementation Y2WConversationResultController
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchStr = @"";
    self.queue = dispatch_queue_create("Y2WConversationResultController", DISPATCH_QUEUE_SERIAL);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[ConversationListCell class] forCellReuseIdentifier:NSStringFromClass([ConversationListCell class])];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 44.0f, 0.0f);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
    NSString *text = searchController.searchBar.text;
    [self searchText:text];
}

- (void)searchText:(NSString *)text {
    if (!text.length) {
        return;
    }
    
    self.searchStr = text;
    
    dispatch_async(self.queue, ^{
        NSMutableArray  *array = [NSMutableArray arrayWithCapacity:0];
        
        Y2WCurrentUser *user = [Y2WUsers getInstance].getCurrentUser;
        
        // 消息
        RLMResults *messageBases = [MessageBase objectsInRealm:user.realm where:@"searchText CONTAINS[c] %@",text];
        messageBases = [messageBases sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"createdAt" ascending:NO]]];
        for (MessageBase *base in messageBases) {
            Y2WSearchReslutModel *model = [[Y2WSearchReslutModel alloc] initWithUserMessageBase:base searchText:text];
            if (model) {
                [array addObject:model];
            }
        }
        
        // 会话
        NSArray *userConversations = [user.userConversations getUserConversations];
        for (Y2WUserConversation *userConversation in userConversations) {
            if ([self modelByTargetId:userConversation.targetId array:array type:userConversation.type]) {
                continue;
            }
            if ([userConversation.name findValue:text].count || [userConversation.text findValue:text].count) {
                [array addObject:[[Y2WSearchReslutModel alloc] initWithUserConversation:userConversation searchText:text]];
            }
        }
        
        // 联系人
        NSArray *contacts = [user.contacts getContacts];
        for (Y2WContact *contact in contacts) {
            if ([self modelByTargetId:contact.userId array:array type:@"p2p"]) {
                continue;
            }
            if ([contact.getName findValue:text].count) {
                [array addObject:[[Y2WSearchReslutModel alloc] initWithUserContact:contact searchText:text]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        });
    });
}

- (Y2WSearchReslutModel *)modelByTargetId:(NSString *)targetId array:(NSArray *)array type:(NSString *)type {
    for (Y2WSearchReslutModel *model in array) {
        if ([model.targetId isEqualToString:targetId] && [model.type isEqualToString:type]) {
            return model;
        }
    }
    return nil;
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConversationListCell *converCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConversationListCell class]) forIndexPath:indexPath];
    
    converCell.searchReslutModel = [self.dataArray objectAtIndex:indexPath.row];

    return converCell;
}




#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Y2WSearchReslutModel *searchReslutModel = [self.dataArray objectAtIndex:indexPath.row];
    
    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:searchReslutModel.targetId type:searchReslutModel.type success:^(Y2WSession *session) {
            
        UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
        ConversationViewController *detailViewController = [[ConversationViewController alloc] initWithSession:session];
        [navigationController pushViewController:detailViewController animated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        [UIAlertView showTitle:nil message:error.message];
    }];
}

- (void)getIMToken:(void (^)())success failure:(void (^)(NSError *))failure{
    Y2WCurrentUserRemote *userRemote = [Y2WUsers getInstance].currentUser.remote;
    [userRemote syncIMToken:^(NSError *error) {
        if(error){
            [self getIMToken:success failure:failure];
            return;
        }else {
            if (success) {
                success();
            }
        }
    }];
}

//创建一个活动指示器
- (void)startProgressHUD:(NSString *)titleStr time:(CGFloat)time{
    if (self.progressHUD) {
        [self hudWasHidden:self.progressHUD];
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.label.text = titleStr;
    [self.progressHUD hideAnimated:YES afterDelay:time];
}

//活动指示器代理
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [hud removeFromSuperview];
    hud = nil;
}


@end
