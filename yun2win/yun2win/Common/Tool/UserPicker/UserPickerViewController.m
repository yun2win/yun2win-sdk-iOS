//
//  UserPickerViewController.m
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserPickerViewController.h"
#import "MemberModelCell.h"
#import "MemberGroupsModel.h"
#import "SessionMemberPickerConfig.h"
#import "SessionMemberModel.h"

@interface UserPickerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSObject<UserPickerConfig> *config;

@property (nonatomic, retain) MemberGroupsModel *members;

@property (nonatomic, retain) NSMutableArray *selectedMembers;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) UserPickerCallBackBlock finishedBlock;

@property (nonatomic, copy) void(^cancelBlock)(void);

@end



@implementation UserPickerViewController

- (instancetype)initWithConfig:(NSObject<UserPickerConfig> *)config {
    
    if (self = [super init]) {
        self.config = config;
        self.selectedMembers = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    
    switch ([self.config type]) {
        case UserPickerTypeContact:
            [self makeContactsData];
            break;
        case UserPickerTypeSessionMember:
            [self makeSessionMembersData];
            break;
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)setUpNavItem{
    self.navigationItem.title = self.config.title;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancell)];
    
    if (self.config.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    }
}




- (void)makeContactsData {
    self.members = [[MemberGroupsModel alloc] init];
    
    NSArray *datas = [[Y2WUsers getInstance].getCurrentUser.contacts getContacts];
    
    for (Y2WContact *contact in datas) {
        if(![self isInFilterForUID:contact.userId]) {
            ContactModel *model = [[ContactModel alloc] initWithContact:contact];
            [self.members addContact:model];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.members.groupModels.count;
    });
}

- (void)makeSessionMembersData
{
    self.members = [[MemberGroupsModel alloc] init];
    
    SessionMemberPickerConfig *config = (SessionMemberPickerConfig *)self.config;
    
    NSArray *datas = [config.session.members getMembers];
    
    for (Y2WSessionMember *member in datas) {
        if(![self isInFilterForUID:member.userId] && ![member.ID isEqualToString:[Y2WUsers getInstance].getCurrentUser.ID]) {
            SessionMemberModel *model = [[SessionMemberModel alloc]initWithSessionMember:member];
            [self.members addContact:model];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.members.groupModels.count;
    });
}

#pragma mark - ———— Response ———— -

- (void)done {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.finishedBlock) {
        self.finishedBlock(self.selectedMembers);
    }
}

- (void)cancell {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)selectMembersCompletion:(UserPickerCallBackBlock)block cancel:(void (^)(void))cancel {
    self.finishedBlock = block;
    self.cancelBlock = cancel;
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
    NSObject<MemberModelInterface> * member = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    cell.model = member;

    if (!cell.isSelected && [self isInSelectedForUID:member.uid]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
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
    NSObject<MemberModelInterface> *member = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    return member.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *member = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
   
    if (!self.config.allowsMultipleSelection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self addSelectedMember:member];
        [self done];
        return;
    }
    
    if ([self canSelectForUID:member.uid]) {
        [self addSelectedMember:member];
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject<MemberModelInterface> *member = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];

    if ([self canDeselectForUID:member.uid]) {
        [self removeSelectedMember:member];

    }else {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}






#pragma mark - ———— Helper ———— -

- (BOOL)canSelectForUID:(NSString *)uid {
    return self.selectedMembers.count < self.config.maxSelectedNum;
}

- (BOOL)canDeselectForUID:(NSString *)uid {
    return ![self.config.alreadySelectedMemberIds containsObject:uid];
}

- (BOOL)isInSelectedForUID:(NSString *)uid {
    if ([self.config.alreadySelectedMemberIds containsObject:uid]) return YES;
    uid = uid.uppercaseString;
    for (NSObject<MemberModelInterface> *member in self.selectedMembers) {
        if ([member.uid isEqualToString:uid]) return YES;
    }
    return NO;
}

- (BOOL)isInFilterForUID:(NSString *)uid {
    return [self.config.filterIds containsObject:uid];
}

- (void)addSelectedMember:(NSObject<MemberModelInterface> *)member {
    [self.selectedMembers addObject:member];
}

- (void)removeSelectedMember:(NSObject<MemberModelInterface> *)member {
    [self.selectedMembers removeObject:member];
}






#pragma mark - ———— getter ———— -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.allowsMultipleSelection = self.config.allowsMultipleSelection;
        _tableView.allowsMultipleSelectionDuringEditing = self.config.allowsMultipleSelection;
        _tableView.editing = self.config.allowsMultipleSelection;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexColor = [ThemeManager sharedManager].currentColor;
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
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
