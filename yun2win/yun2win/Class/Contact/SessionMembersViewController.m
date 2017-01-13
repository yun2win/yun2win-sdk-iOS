//
//  SessionMembersViewController.m
//  API
//
//  Created by QS on 16/3/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SessionMembersViewController.h"
#import "UserPickerViewController.h"
#import "ContactPickerConfig.h"
#import "MemberGroupsModel.h"
#import "MemberModelCell.h"
#import "SessionMemberModel.h"
#import "ProfileViewController.h"
#import "EmailInviteViewController.h"

@interface SessionMembersViewController ()<UITableViewDataSource,UITableViewDelegate,Y2WSessionMembersDelegate>

@property (nonatomic, weak) Y2WSessionMembers *sessionMembers;

@property (nonatomic, weak) Y2WSessionMember *currrentMember;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) MemberGroupsModel *members;

@property (nonatomic, strong) UISearchController *searchController;

@end


@implementation SessionMembersViewController

- (void)dealloc {
    [self.sessionMembers removeDelegate:self];
}

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)sessionMembers {
    if (self = [super init]) {
        self.sessionMembers = sessionMembers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    
    [self.sessionMembers addDelegate:self];
    [self reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)setUpNavItem{
    self.navigationItem.title = @"群成员";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_加号"] style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
}



#pragma mark - ———— Response ———— -

- (void)showAlert {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *addMemberAction = [UIAlertAction actionWithTitle:@"添加群成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addMember];
    }];
    UIAlertAction *emailInviteAction = [UIAlertAction actionWithTitle:@"邮件邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EmailInviteViewController *emailInviteVC = [[EmailInviteViewController alloc] initWithSessionMembers:self.sessionMembers];
        [self.navigationController pushViewController:emailInviteVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:addMemberAction];
    [alertVC addAction:emailInviteAction];
    [self.navigationController showDetailViewController:alertVC sender:nil];
}

- (void)addMember {
    
    ContactPickerConfig *config = [[ContactPickerConfig alloc] init];
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {

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

        [self.navigationItem startAnimating];
        __unsafe_unretained SessionMembersViewController *weakSelf = self;
        [self.sessionMembers.remote addSessionMembers:sessionMembers success:^{
            
            [weakSelf.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            [weakSelf.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:error.message];
        }];

    } cancel:nil];
    
    [self pushViewController:userPickerVC];
}



#pragma mark - ———— Response ———— -

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)reloadData {
    
    self.members = [[MemberGroupsModel alloc] init];
    
    NSArray *datas = [self.sessionMembers getMembers];
    
    for (Y2WSessionMember *sessionMember in datas) {
        SessionMemberModel *model = [[SessionMemberModel alloc] initWithSessionMember:sessionMember];
        [self.members addContact:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.members.groupModels.count;
    });
}








#pragma mark - ———— Y2WSessionMembersDelegate ———— -

- (void)sessionMembersDidChangeContent:(Y2WSessionMembers *)sessionMembers {
    [self reloadData];
}





#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.members.groupModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.members groupModelForRowAtSection:section].contacts.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberModelCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberModelCell class])];
    
    cell.model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.members titles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.members sectionForGroupTitle:title];
}


#pragma mark - ———— UITableViewDelegate ———— -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    label.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
    label.textColor = [UIColor colorWithHexString:@"353535"];
    label.font = [UIFont systemFontOfSize:14];
    
    NSString *text = [[self.members groupModelForRowAtSection:section] groupTitle];
    NSMutableAttributedString *aText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10;
    [aText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    label.attributedText = aText;
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.members groupModelForRowAtSection:section] groupTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    if ([model isKindOfClass:[SessionMemberModel class]]) {
        Y2WSessionMember *member = [(SessionMemberModel *)model sessionMember];
        Y2WUser *user = [[Y2WUsers getInstance] getUserById:member.userId];
        if (!user) {
            return;
        }
        ProfileViewController *userVC = [[ProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    if ([model isKindOfClass:[SessionMemberModel class]]) {
        Y2WSessionMember *member = [(SessionMemberModel *)model sessionMember];
        return [self canDeleteMember:member] || [self canSetMasterToMember:member] || [self canSetManagerToMember:member];
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    
    if ([model isKindOfClass:[SessionMemberModel class]]) {
        
        Y2WSessionMember *member = [(SessionMemberModel *)model sessionMember];
        
        NSMutableArray *actions = [NSMutableArray array];
        
        if ([self canDeleteMember:member]) {
            [actions addObject:[self deleteActionWithSessionMember:member]];
        }
        if ([self canSetMasterToMember:member]) {
            [actions addObject:[self setMasterActionWithSessionMember:member]];
        }
        if ([self canSetManagerToMember:member]) {
            [actions addObject:[self setManagerActionWithSessionMember:member]];
        }

        return actions;
    }
    return nil;
}



#pragma mark - ———— Helper ———— -

- (UITableViewRowAction *)deleteActionWithSessionMember:(Y2WSessionMember *)member {
    
    return [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        [self.navigationItem startAnimating];
        [self.sessionMembers.remote deleteSessionMember:member success:^{
            [self.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:error.message];
        }];
    }];
}

- (UITableViewRowAction *)setMasterActionWithSessionMember:(Y2WSessionMember *)member {
    
    return [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"转让群主" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        member.role = @"master";
        [self updateSessionMember:member];
        
        self.currrentMember.role = @"admin";
        [self updateSessionMember:self.currrentMember];
    }];
}

- (UITableViewRowAction *)setManagerActionWithSessionMember:(Y2WSessionMember *)member {
    
    BOOL isManager = [member.role isEqualToString:@"admin"];
    NSString *title = isManager ? @"撤销管理员":@"设置管理员";
    return [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        member.role = isManager ? @"user" : @"admin";
        [self updateSessionMember:member];
    }];
}



- (void)updateSessionMember:(Y2WSessionMember *)member {
    
    [self.navigationItem startAnimating];
    [self.sessionMembers.remote updateSessionMember:member success:^{
        [self.navigationItem stopAnimating];
        
    } failure:^(NSError *error) {
        [self.navigationItem stopAnimating];
        [UIAlertView showTitle:nil message:error.message];
    }];
}



// 是否能删除此成员
- (BOOL)canDeleteMember:(Y2WSessionMember *)member {
    if ([self.currrentMember.userId isEqualToString:member.userId]) {
        return NO;
    }else if ([self.currrentMember.role isEqualToString:@"master"]) {
        return YES;
    } if ([self.currrentMember.role isEqualToString:@"admin"]) {
        return [member.role isEqualToString:@"user"];
    }
    return NO;
}

// 是否能设置此成员为群主
- (BOOL)canSetMasterToMember:(Y2WSessionMember *)member {
    if ([self.currrentMember.userId isEqualToString:member.userId]) {
        return NO;
    }else if ([self.currrentMember.role isEqualToString:@"master"]) {
        return YES;
    }
    return NO;
}

// 是否能设置此成员为管理员
- (BOOL)canSetManagerToMember:(Y2WSessionMember *)member {
    if ([self.currrentMember.userId isEqualToString:member.userId]) {
        return NO;
    }else if ([self.currrentMember.role isEqualToString:@"master"]) {
        return YES;
    }
    return NO;
}







#pragma mark - ———— getter ———— -

- (Y2WSessionMember *)currrentMember {
    if (!_currrentMember) {
        _currrentMember = [self.sessionMembers getMemberWithUserId:[Y2WUsers getInstance].getCurrentUser.ID];
    }
    return _currrentMember;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
   
    }
    return _searchController;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexColor = [ThemeManager sharedManager].currentColor;
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionHeaderHeight = 16;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage y2w_imageNamed:@"默认图-会话"]];
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        [_tableView registerClass:[MemberModelCell class] forCellReuseIdentifier:NSStringFromClass([MemberModelCell class])];
    }
    return _tableView;
}

@end
