//
//  ProfileViewController.m
//  API
//
//  Created by QS on 16/8/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ProfileViewController.h"
#import "ConversationViewController.h"
#import "SettingTableViewUserCell.h"
#import "SettingTableViewCellModel.h"
#import "Y2WImagePickerController.h"

@interface ProfileViewController ()

@property (nonatomic, retain) Y2WUser *user;

@property (nonatomic, retain) NSArray *sections;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startChat;

@end

@implementation ProfileViewController

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)initWithUser:(Y2WUser *)user {
    if (self = [super init]) {
        self.user = user;
        if ([self isCurrentUser]) {
            self.user = [Y2WUsers getInstance].getCurrentUser;
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SettingTableViewCell class])];
    [_tableView registerClass:[SettingTableViewUserCell class] forCellReuseIdentifier:NSStringFromClass([SettingTableViewUserCell class])];
    
    [self reloadData];
    
    [[Y2WUsers getInstance].remote getUserById:self.user.ID success:^(Y2WUser *user) {
        [self reloadData];
    } failure:nil];
}

- (void)setUpNavItem {
    self.navigationItem.title = @"个人详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_返回"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
}





- (void)reloadData {
    NSMutableArray *sectons = [NSMutableArray array];
    
    SettingTableViewCellModel *sessionInfo = [[SettingTableViewCellModel alloc] init];
    sessionInfo.title = self.user.name;
    sessionInfo.detailTitle = [NSString stringWithFormat:@"账号: %@",self.user.email];
    sessionInfo.uid = self.user.ID;
    sessionInfo.avatarUrl = self.user.avatarUrl;
    sessionInfo.image = [UIImage y2w_imageNamed:@"默认个人头像"];
    sessionInfo.cellClass = [SettingTableViewUserCell class];
    sessionInfo.cellAction = @selector(clickAvatar);
    sessionInfo.rowHeight = 80;
    sessionInfo.showAccessory = YES;
    [sectons addObject:@[sessionInfo]];
    
    
    if ([self isCurrentUser]) {
        SettingTableViewCellModel *name = [[SettingTableViewCellModel alloc] init];
        name.title = @"修改名字";
        name.cellClass = [SettingTableViewCell class];
        name.cellAction = @selector(clickName);
        name.rowHeight = 50;
        name.showAccessory = YES;

        SettingTableViewCellModel *password = [[SettingTableViewCellModel alloc] init];
        password.title = @"修改密码";
        password.cellClass = [SettingTableViewCell class];
        password.cellAction = @selector(clickPassword);
        password.rowHeight = 50;
        password.showAccessory = YES;
        [sectons addObject:@[name,password]];
        self.startChat.hidden = YES;
        
    }else if ([self isContact]) {
        Y2WContact *contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.user.ID];
        SettingTableViewCellModel *title = [[SettingTableViewCellModel alloc] init];
        title.title = @"备注";
        title.detailTitle = contact.title;
        title.cellClass = [SettingTableViewCell class];
        title.cellAction = @selector(clickTitle);
        title.rowHeight = 50;
        title.showAccessory = YES;
        [sectons addObject:@[title]];
    }
    
    self.sections = sectons;
    [self.tableView reloadData];
}




#pragma mark - ———— Business ———— -

- (void)changeAvatarWithImage:(UIImage *)image {
    [self.navigationItem startAnimating];
    NSString *path = [image writePNG];
    
    [[Y2WUsers getInstance].getCurrentUser.attachments uploadFile:path progress:nil success:^(Y2WAttachment *attachment) {
        
        self.user.avatarUrl = attachment.url;
        [[Y2WUsers getInstance].getCurrentUser.remote store:^(NSError *error) {
            [self.navigationItem stopAnimating];
            if (!error) {
                [self reloadData];
            }
            [UIAlertView showTitle:nil message:error.message ?: @"头像更换成功"];
        }];
        
    } failure:^(NSError *error) {
        [self.navigationItem stopAnimating];
        [UIAlertView showTitle:nil message:error.message];
    }];
}

- (void)changeName:(NSString *)name {
    if (!name.length) {
        [UIAlertView showTitle:nil
                       message:@"请输入字符"];
        return;
    }
    self.user.name = name;
    [[Y2WUsers getInstance].getCurrentUser.remote store:^(NSError *error) {
        [self.navigationItem stopAnimating];
        if (!error) {
            [self reloadData];
        }
        [UIAlertView showTitle:nil message:error.message ?: @"修改成功"];
    }];
}

- (void)changePassword:(NSString *)password fromOldPassword:(NSString *)oldPassword {
    [self.navigationItem startAnimating];
    [[Y2WUsers getInstance].getCurrentUser.remote setPassword:password
                                              fromOldPassword:oldPassword
                                                   completion:^(NSError *error) {
                                                       [self.navigationItem stopAnimating];
                                                       [UIAlertView showTitle:nil message:error ? error.message : @"修改成功"];
                                                   }];
}

- (void)changeTitle:(NSString *)title {
    Y2WContact *contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.user.ID];
    Y2WContact *newContact = [[Y2WContact alloc] init];
    newContact.ID = contact.ID;
    newContact.userId = contact.userId;
    newContact.name = contact.name;
    newContact.title = title ?: @"";
    
    [self.navigationItem startAnimating];
    [[Y2WUsers getInstance].getCurrentUser.contacts.remote updateContact:newContact
                                                                 success:^{
                                                                     [self.navigationItem stopAnimating];
                                                                     [self reloadData];
                                                                     
                                                                 } failure:^(NSError *error) {
                                                                     [self.navigationItem stopAnimating];
                                                                     [UIAlertView showTitle:nil message:error.message];
                                                                 }];
}


#pragma mark - ———— Response ———— -

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickAvatar {
    if (![self isCurrentUser]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更换头像"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                Y2WImagePickerController *imagePC = [Y2WImagePickerController pickerWithType:UIImagePickerControllerSourceTypePhotoLibrary handler:^(UIImage *image) {
                                                    
                                                    [self changeAvatarWithImage:[image scaleToAvatar]];
                                                }];
                                                [self showDetailViewController:imagePC sender:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                Y2WImagePickerController *imagePC = [Y2WImagePickerController pickerWithType:UIImagePickerControllerSourceTypeCamera handler:^(UIImage *image) {
                                                    [self changeAvatarWithImage:image];
                                                }];
                                                [self showDetailViewController:imagePC sender:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self showDetailViewController:alert sender:nil];
}

- (void)clickName {
    if (![self isCurrentUser]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改名字"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.returnKeyType = UIReturnKeyDone;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self changeName:alert.textFields.firstObject.text];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self showDetailViewController:alert sender:nil];
}

- (void)clickPassword {
    if (![self isCurrentUser]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改密码"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入旧密码";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入新密码";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self changePassword:alert.textFields.lastObject.text fromOldPassword:alert.textFields.firstObject.text];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self showDetailViewController:alert sender:nil];
}

- (void)clickTitle {
    if (![self isContact]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改备注"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.text = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:weakSelf.user.ID].title;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [weakSelf changeTitle:alert.textFields.firstObject.text];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self showDetailViewController:alert sender:nil];
}


- (IBAction)startChat:(UIButton *)sender {
    [self.navigationItem startAnimating];
    sender.enabled = NO;

    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count >= 2) {
        UIViewController *viewController = viewControllers[viewControllers.count - 2];
        if ([viewController isKindOfClass:[ConversationViewController class]]) {
            if ([[(ConversationViewController *)viewController session].type isEqualToString:@"p2p"] &&
                [self.user.ID isEqualToString:[(ConversationViewController *)viewController session].targetId]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }

    [self.user getSessionAndAddContact:^(NSError *error, Y2WSession *session) {
        [self.navigationItem stopAnimating];
        sender.enabled = YES;

        if (error) {
            return [UIAlertView showTitle:nil message:error.message];
        }
        
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        [self pushViewController:conversationVC];
    }];
}



#pragma mark - ———— Helper ———— -

- (BOOL)isCurrentUser {
    return [self.user.ID isEqualToString:[Y2WUsers getInstance].getCurrentUser.ID];
}

- (BOOL)isContact {
    return !![[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.user.ID];
}


#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.sections[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCellModel *model = self.sections[indexPath.section][indexPath.row];
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(model.cellClass)];
    [cell relodData:model tableView:tableView];
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCellModel *model = self.sections[indexPath.section][indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingTableViewCellModel *model = self.sections[indexPath.section][indexPath.row];
    
    if ([self respondsToSelector:model.cellAction]) {
        [self y2w_performSelector:model.cellAction];
    }
}

@end
