//
//  ConversationViewController.m
//  API
//
//  Created by QS on 16/1/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ConversationViewController.h"
#import "GroupViewController.h"
#import "MessageCell.h"
#import "MessageNotiCell.h"
#import "InputView.h"
#import "MessageCellDelegate.h"
#import "SessionMemberPickerConfig.h"
#import "SessionMemberModel.h"
#import "UserPickerViewController.h"
#import "FileAppend.h"
#import "Y2WTextMessage.h"
#import "LocationViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ProfileViewController.h"
#import "MembersReadMessageViewController.h"
#import "Y2WMessagesPage.h"
#import "WebViewController.h"
#import "MessageAudioBubbleView.h"
#import "MembersReadMessagePageController.h"
#import "MainViewController.h"

@interface ConversationViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
InputViewUIDelegate,
InputViewActionDelegate,
InputViewMoreDelegate,
Y2WMessagesDelegate,
Y2WSessionMembersDelegate,
MessageCellDelegate,
Y2WAudioPlayerDelegate,
Y2WMessagesPageDelegate
>

@property (nonatomic, retain) Y2WUserConversation *userConversation;

@property (nonatomic, retain) MessageCellConfig *cellConfig;

@property (nonatomic, retain) Y2WMessagesPage *page;

@property (nonatomic, retain) Y2WAudioPlayer *player;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) InputView *inputView;

@property (nonatomic, retain) UIRefreshControl *control;

@property (nonatomic, retain) NSMutableArray *inputSelectedMembers; // @成员


@end


@implementation ConversationViewController {
    NSIndexPath *_playAudioIndexPath;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)dealloc {
    [self.session.messages removeDelegate:self];
}

- (instancetype)initWithSession:(Y2WSession *)session {
    if (self = [super init]) {
        self.inputSelectedMembers = [NSMutableArray array];
        self.session = session;
        self.cellConfig = [[MessageCellConfig alloc] init];
        self.page = [[Y2WMessagesPage alloc] initWithSessionId:self.session.ID];
        self.page.delegate = self;
        self.player = [[Y2WAudioPlayer alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];

    [self.navigationItem startAnimating];
    [self.session.messages addDelegate:self];
    [self.session.messages loadMessageFromDelegate:self];
    [self.session.members addDelegate:self];
    
    self.inputView.textView.text = self.userConversation.draft;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.session.getName;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.userConversation.draft = self.inputView.textView.text;
}

- (void)setUpNavItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_返回"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
    
    if ([self.session.type isEqualToString:@"p2p"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_个人信息"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(p2pRightBarButtonItemClick)];
        
    }
    else if ([self.session.type isEqualToString:@"group"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_群信息"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(groupRightBarButtonItemClick)];
    }
}

#pragma mark - ———— Response ———— -

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p2pRightBarButtonItemClick {
    [self onTapAvatar:self.session.targetId];
}

- (void)groupRightBarButtonItemClick {
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSesstion:self.session];
    [self pushViewController:groupViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView endEditing:YES];
}

- (void)sendMessage:(Y2WBaseMessage *)message {
    //段洪亮加的代码开始
    RLMRealm *realm = self.session.sessions.user.realm;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:[message.content toJsonString] forKey:@"content"];
    [tempDic setObject:@"2019-10-11T10:38:17.000Z" forKey:@"createdAt"];
    [tempDic setObject:@"2019-10-11T10:38:17.000Z" forKey:@"updatedAt"];
    [tempDic setObject:message.ID forKey:@"id"];
    [tempDic setObject:@"0" forKey:@"isDelete"];
    [tempDic setObject:message.sender forKey:@"sender"];
    [tempDic setObject:message.sessionId forKey:@"sessionId"];
    [tempDic setObject:message.type forKey:@"type"];
    [tempDic setObject:self.session.ID forKey:@"sessionId"];
    [tempDic setObject:@"storing" forKey:@"status"];
    [realm transactionWithBlock:^{
        [MessageBase createOrUpdateInRealm:realm withValue:tempDic];
    }];
    //段洪亮加的代码结束
    
    [self.session.messages sendMessage:message];
    
    if ([message.type isEqualToString:@"text"] ||
        [message.type isEqualToString:@"task"]) {
        
        [self.inputSelectedMembers removeAllObjects];
        [self.inputView.textView clearText];
        // 清除草稿
        self.userConversation.draft = nil;
    }
}


#pragma mark - ———— Y2WSessionMembersDelegate ———— -

- (void)sessionMembersDidChangeContent:(Y2WSessionMembers *)sessionMembers {
    [self.tableView reloadData];
}


#pragma mark - ———— Y2WMessagesDelegate ———— -
// 消息同步完成
- (void)messages:(Y2WMessages *)messages didFistSyncWithError:(NSError *)error {
    if (error) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeText;
        hub.label.text = error.message;
        [hub hideAnimated:YES afterDelay:1];
    }
    [self.page start];
}

- (void)messages:(Y2WMessages *)messages sendMessage:(Y2WBaseMessage *)message didCompleteWithError:(NSError *)error {
//    RLMRealm *realm = self.session.sessions.user.realm;
//    MessageBase *base = [MessageBase objectInRealm:realm forPrimaryKey:message.ID];
    [self.tableView reloadData];
}


#pragma mark - ———— Y2WMessagesPageDelegate ———— -
// 加载首屏消息
- (void)messagePage:(Y2WMessagesPage *)page didLoadMessages:(RLMResults<MessageBase> *)messages {
    [self.navigationItem stopAnimating];

    [self.tableView reloadData];
    [self.tableView scrollToLastIndexPath:NO];
}

// 加载上一页消息
- (void)messagePage:(Y2WMessagesPage *)page didLoadLastMessages:(RLMArray<MessageBase> *)messages {
    if (!messages.count) {
        return [self.control endRefreshing];
    }
    
    CGFloat totalheight = 0;
    for (MessageBase *message in messages) {
        totalheight += message.cellHeight;
    }
    
    [self.tableView reloadData];
    CGPoint offset = self.tableView.contentOffset;
    offset.y += totalheight;
    [self.tableView setContentOffset:offset];
    [self.control endRefreshing];
}

// 当前消息变更
- (void)messagePage:(Y2WMessagesPage *)page
didDeleteIndexPaths:(NSArray<NSIndexPath *> *)deleteIndexPaths
 didInsetIndexPaths:(NSArray<NSIndexPath *> *)insetIndexPaths
didReloadIndexPaths:(NSArray<NSIndexPath *> *)reloadIndexPaths {
    
    UITableView *tableView = self.tableView;
    
    BOOL needAutoScrollToBottom = [tableView isVisibleLastIndexPath];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:deleteIndexPaths
                     withRowAnimation:UITableViewRowAnimationNone];
    [tableView insertRowsAtIndexPaths:insetIndexPaths
                     withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths
                     withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    
    if (needAutoScrollToBottom) {
        [tableView scrollToLastIndexPath:YES];
    }
}



#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.page.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row + self.page.offset;
    MessageBase *messageBase = self.page.messages[index];
    Class cellClass = [MessageCellConfig cellClassWithMessageBase:messageBase];
    UITableViewCell<MessageCellModelInterface> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    [cell setMessageDelegate:nil];
    MessageModel *model = [self modelWithMessageBase:messageBase];
    [cell setMessageDelegate:self];
    [cell refreshData:model];
    
    
    if ([messageBase.type isEqualToString:@"audio"]) {
        MessageCell *audioCell = (MessageCell *)cell;
        MessageAudioBubbleView *bubbleView = (MessageAudioBubbleView *)audioCell.bubbleView;
        bubbleView.animating = [indexPath isEqual:_playAudioIndexPath];
    }
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBase *messageBase = self.page.messages[indexPath.row + self.page.offset];
    return messageBase.cellHeight;
}


#pragma mark - ———— InputViewUIDelegate ———— -

- (void)inputView:(InputView *)inputView didChangeTop:(CGFloat)top{
    self.tableView.frame = CGRectMake(0, 0, self.view.size.width, self.view.size.height - self.inputView.frame.size.height);
    self.tableView.height = top;
    [self.tableView scrollToLastIndexPath:YES];
}

- (void)inputView:(InputView *)inputView showKeyboard:(CGFloat)show {
    self.tableView.userInteractionEnabled = !show;
}

- (void)inputView:(InputView *)inputView didInputText:(NSString *)text {
    // 如果输入的是@并且在群聊内，则选择群成员
    if ([text isEqualToString:@"@"] && [self.session.type isEqualToString:@"group"]) {
        SessionMemberPickerConfig *config = [[SessionMemberPickerConfig alloc]initWithSession:self.session];
        UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
        [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {
            [self.inputView.textView deleteBackward];
            [self.inputView.textView insertText:@" "];
            for (SessionMemberModel *member in members) {
                if (member.sessionMember.user) {
                    [self.inputView.textView insertText:[NSString stringWithFormat:@"@%@ ",member.name]];
                }
                [self.inputSelectedMembers addObject:@{@"id":member.uid, @"name": member.name}];
            }
        } cancel:nil];
        [self pushViewController:userPickerVC];
    }
}

- (void)inputView:(InputView *)inputView onSendText:(NSString *)text {
    Y2WTextMessage *message = [self.session.messages messageWithText:text];
    NSMutableArray *inputSelectedMembers = [NSMutableArray array];
    {// 取@成员
        for (NSDictionary *memberDict in self.inputSelectedMembers.mutableCopy) {
            if ([text containsString:[NSString stringWithFormat:@"@%@",memberDict[@"name"]]]) {
                [inputSelectedMembers addObject:memberDict];
            }
        }
    }

    {// 如果有@成员就加入消息体。如果是任务消息则没有@成员就添加当前用户
        if (inputSelectedMembers.count) {
            NSMutableDictionary *content = message.content.mutableCopy;
            content[@"users"] = inputSelectedMembers;
            message.content = content;
        }
//        else if ([message.type isEqualToString:@"task"]) {
//            if ([self.session.type isEqualToString:@"group"]) {
//                [inputSelectedMembers addObject:@{@"id":self.session.sessions.user.ID, @"name":self.session.sessions.user.name}];
//            }
//            else if ([self.session.type isEqualToString:@"p2p"]) {
//                Y2WSessionMember *member = [self getOtherMember];
//                if (member) {
//                    [inputSelectedMembers addObject:@{@"id":member.userId, @"name":member.name}];
//                }
//            }
//        }
    }
    
    {// 发送普通消息
        [self sendMessage:message];
    }
}

- (void)inputView:(InputView *)inputView onSendVoice:(NSString *)voicePath time:(NSInteger)timer {
    Y2WAudioMessage *message = [self.session.messages messageWithAudioPath:voicePath timer:timer];
    [self.session.messages sendMessage:message];
}

- (void)moreInputViewDidSelectItem:(MoreItem *)item {
    if ([item.title isEqualToString:@"图片"]) {
        Y2WImagePickerController *imagePC = [Y2WImagePickerController pickerWithType:UIImagePickerControllerSourceTypePhotoLibrary handler:^(UIImage *image) {
            Y2WImageMessage *message = [self.session.messages messageWithImage:image];
            [self.session.messages sendMessage:message];
        }];
        imagePC.allowsEditing = NO;
        [self showDetailViewController:imagePC sender:nil];
    }
    
    if ([item.title isEqualToString:@"拍照"]) {
        Y2WImagePickerController *imagePC = [Y2WImagePickerController pickerWithType:UIImagePickerControllerSourceTypeCamera handler:^(UIImage *image) {
            Y2WImageMessage *message = [self.session.messages messageWithImage:image];
            [self.session.messages sendMessage:message];
        }];
        imagePC.allowsEditing = NO;
        [self showDetailViewController:imagePC sender:nil];
    }
    
    if ([item.title isEqualToString:@"小视频"]) {
        Y2WImagePickerController *imagePC = [Y2WImagePickerController videoPickerWithMaximumDuration:15 handler:^(NSString *path, UIImage *image) {
            Y2WVideoMessage *message = [self.session.messages messageWithVideoPath:path];
            [self.session.messages sendMessage:message];
        }];
        [self showDetailViewController:imagePC sender:nil];
    }
    
    if ([item.title isEqualToString:@"位置"]) {
        LocationViewController *location = [[LocationViewController alloc] initWithHandler:^(LocationPoint *point) {
            Y2WLocationMessage *message = [self.session.messages messageWithLocationPoint:point];
            [self.session.messages sendMessage:message];
        }];
        [self.navigationController pushViewController:location animated:YES];
    }
    
    if ([item.title isEqualToString:@"文档"]) {
        
    }
    
//    if ([item.title isEqualToString:@"快速任务"]) {
//        if (![self.inputView.textView.text isTask]) {
//            self.inputView.textView.text = [@"/task" stringByAppendingString:self.inputView.textView.text ?: @""];
//        }
//    }
}




#pragma mark - MessageCellDeleagte

- (void)onTapAvatar:(NSString *)userId {
    Y2WUser *user = [[Y2WUsers getInstance] getUserById:userId];
    if (!user) {
        return;
    }
    ProfileViewController *userVC = [[ProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)onLongPressCell:(Y2WBaseMessage *)message inView:(UIView *)view
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([message.type isEqualToString:@"text"]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self copyMessage:message];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"引用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self quoteMessage:message];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self transmitMessage:message];
    }]];
    
    if ([message.sender isEqualToString:[[Y2WUsers getInstance]getCurrentUser].ID]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"撤回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self revokeMessage:message];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [self.navigationController showDetailViewController:alert sender:nil];
}

- (void)messageCell:(MessageCell *)cell didClickBubbleView:(UIView *)view message:(Y2WBaseMessage *)message {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([message.type isEqualToString:@"location"]) {
        Y2WLocationMessage *locationMessage = (Y2WLocationMessage *)message;
        LocationPoint *locationPoint = [[LocationPoint alloc]initWithMessage:locationMessage];
        LocationViewController *location = [[LocationViewController alloc]initWithLocationPoint:locationPoint];
        [self.navigationController pushViewController:location animated:YES];
    }
    else if ([message.type isEqualToString:@"image"]) {
        Y2WImageMessage *imageMessage = (Y2WImageMessage *)message;
        Y2WAttachment *attachment = imageMessage.attachment;
        if (attachment) {
            IDMPhoto *photo = [[IDMPhoto alloc] initWithURL:[NSURL URLWithString:attachment.url]];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
            [self presentViewController:browser animated:YES completion:nil];
        }
        else {
            [self.session.sessions.user.attachments getAttachmentById:imageMessage.attachmentId success:^(Y2WAttachment *attachment) {
                imageMessage.attachment = attachment;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self messageCell:cell didClickBubbleView:view message:imageMessage];
                
            } failure:^(NSError *error) {
                [UIAlertView showTitle:nil message:error.message];
            }];
        }
    }
    else if ([message.type isEqualToString:@"audio"]) {
        Y2WAudioMessage *audioMessage = (Y2WAudioMessage *)message;
        BOOL needPlay = !(_playAudioIndexPath && [indexPath isEqual:_playAudioIndexPath]);
        [self.player stop];
        if (needPlay) {
            _playAudioIndexPath = indexPath;
            [self.player playWithAttachmentId:audioMessage.attachmentId];
        }
    }
    else if ([message.type isEqualToString:@"video"]) {
        Y2WVideoMessage *videoMessage = (Y2WVideoMessage *)message;
        Y2WAttachment *attachment = videoMessage.attachment;
        if (attachment.isDownloaded) {
            NSURL *url = [NSURL fileURLWithPath:attachment.path];
            DocumentItem *item = [[DocumentItem alloc] initWithURL:url title:@"视频"];
            DocumentViewController *documentVC = [[DocumentViewController alloc] initWithItems:@[item] currentItem:item];
            [self presentViewController:documentVC animated:YES completion:nil];
        }
        else {
            if (attachment.task) {
                if (attachment.task.state == NSURLSessionTaskStateSuspended) {
                    [attachment.task resume];
                }
                else {
                    [attachment.task suspend];
                }
            }
            else {
                [self.session.sessions.user.attachments getAttachmentById:videoMessage.attachmentId success:^(Y2WAttachment *attachment) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [attachment download];
                    
                } failure:^(NSError *error) {
                    [UIAlertView showTitle:nil message:error.message];
                }];
            }
        }
    }
    else if ([message.type isEqualToString:@"file"]) {
        Y2WFileMessage *fileMessage = (Y2WFileMessage *)message;
        Y2WAttachment *attachment = fileMessage.attachment;
        if (attachment.isDownloaded) {
            NSURL *url = [NSURL fileURLWithPath:attachment.path];
            DocumentItem *item = [[DocumentItem alloc] initWithURL:url title:fileMessage.name];
            DocumentViewController *documentVC = [[DocumentViewController alloc] initWithItems:@[item] currentItem:item];
            [self presentViewController:documentVC animated:YES completion:nil];
        }
        else {
            if (attachment.task) {
                if (attachment.task.state == NSURLSessionTaskStateSuspended) {
                    [attachment.task resume];
                }
                else {
                    [attachment.task suspend];
                }
            }
            else {
                [self.session.sessions.user.attachments getAttachmentById:fileMessage.attachmentId success:^(Y2WAttachment *attachment) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [attachment download];
                    
                } failure:^(NSError *error) {
                    [UIAlertView showTitle:nil message:error.message];
                }];
            }
        }
    }
    else {// 弹窗
        NSMutableArray *actions = [NSMutableArray array];
        
        {// 查找链接
            for (NSString *url in [message.text findLinkURL]) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:url style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    WebViewController *webVC = [[WebViewController alloc] initWithUrl:url];
                    [self pushViewController:webVC animated:YES];
                }];
                [actions addObject:action];
            }
        }
        
        {// 查找@成员
            for (NSDictionary *dict in message.users) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:[@"@" stringByAppendingString:dict[@"name"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[Y2WUsers getInstance] getUserById:dict[@"id"] success:^(Y2WUser *user) {
                        ProfileViewController *userVC = [[ProfileViewController alloc] initWithUser:user];
                        [self.navigationController pushViewController:userVC animated:YES];
                    } failure:^(NSError *error) {
                        [UIAlertView showTitle:nil message:error.message];
                    }];
                }];
                [actions addObject:action];
            }
        }
        
        {// 显示弹窗
            if (actions.count) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                for (UIAlertAction *action in actions) {
                    [alert addAction:action];
                }
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self.navigationController showDetailViewController:alert sender:nil];
                return;
            }
        }
    }
}

- (void)messageCell:(MessageCell *)cell didClickRetryWithMessage:(Y2WBaseMessage *)message {
    RLMRealm *realm = self.session.sessions.user.realm;
    MessageBase *baseMess = [MessageBase objectInRealm:realm forPrimaryKey:message.ID];
    [realm transactionWithBlock:^{
        baseMess.status = @"storing";
    }];
    NSIndexPath *indePath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indePath] withRowAnimation:UITableViewRowAnimationNone];
    [self.session.messages sendMessage:message];
}

- (void)messageCell:(MessageCell *)cell didClickReadedWithMessage:(Y2WBaseMessage *)message {
    if (![self.session.type isEqualToString:@"group"]) {
        return;
    }
    NSMutableArray *readedMembers = [NSMutableArray array];
    NSMutableArray *unreadMembers = [NSMutableArray array];
    for (Y2WSessionMember *member in self.session.members.getMembers) {
        if ([member.userId isEqualToString:[Y2WUsers getInstance].getCurrentUser.ID]) {
            continue;
        }
        
        if ([member.lastReadTime.y2w_toDate isLaterThan:message.createdAt.y2w_toDate]) {
            [readedMembers addObject:member];
        }else {
            [unreadMembers addObject:member];
        }
    }
    
#warning todo 已读未读
//    MembersReadMessagePageController *membersReadVC = [[MembersReadMessagePageController alloc] init];
    
    MembersReadMessageViewController *membersReadVC = [[MembersReadMessageViewController alloc] init];
    membersReadVC.title = @"已读成员";
    membersReadVC.members = readedMembers;
    [self.navigationController pushViewController:membersReadVC animated:YES];
}



#pragma mark - ———— Helper ———— -

- (MessageModel *)modelWithMessageBase:(MessageBase *)messageBase {
    Y2WBaseMessage *message = [Y2WBaseMessage createMessageWithDict:messageBase.toDict];
    MessageModel *model = [[MessageModel alloc] initWithMessage:message];
    model.member = [self.session.members getMemberWithUserId:message.sender];
    model.cellConfig = self.cellConfig;
    [model cleanCache];
    [model calculateContent:self.tableView.width];
    return model;
}

- (Y2WSessionMember *)getOtherMember {
    NSString *currentUid = [Y2WUsers getInstance].getCurrentUser.ID;
    for (Y2WSessionMember *member in self.session.members.getMembers) {
        if (![member.userId isEqualToString:currentUid]) {
            return member;
        }
    }
    return nil;
}



- (void)copyMessage:(Y2WBaseMessage *)message
{
    if ([message.type isEqualToString:@"text"]) {
        if (message.text.length) {
            //剪贴板
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:message.text];
        }
    }
}

- (void)quoteMessage:(Y2WBaseMessage *)message
{
    Y2WUser *sender = [[Y2WUsers getInstance] getUserById:message.sender];
    NSString *text = [NSString stringWithFormat:@"「%@: %@」\n—————————",sender.name,message.text];
    self.inputView.textView.text = text;
}

- (void)transmitMessage:(Y2WBaseMessage *)message
{
    ContactPickerConfig *config = [[ContactPickerConfig alloc] init];
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {
        for (NSObject<MemberModelInterface> *member in members) {
            Y2WContact *transmitContact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:member.uid];
            [transmitContact getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
                
                MessageBase *base = [MessageBase objectInRealm:[[Y2WUsers getInstance] getCurrentUser].realm forPrimaryKey:message.ID];
                Y2WBaseMessage *newMessage = [self modelWithMessageBase:base].message;
                newMessage.sender = self.session.sessions.user.ID;
                newMessage.ID = [NSUUID UUID].UUIDString;
                newMessage.sessionId = session.ID;
                [session.messages sendMessage:newMessage];
            }];
        }
    } cancel:nil];
    [self pushViewController:userPickerVC];
}

- (void)revokeMessage:(Y2WBaseMessage *)message
{
    Y2WBaseMessage *uMessage = message;
    uMessage.sessionId = self.session.ID;
    uMessage.type = @"system";
    uMessage.content = @{@"text":[NSString stringWithFormat:@"%@撤回了一条信息",[Y2WUsers getInstance].getCurrentUser.name]};
    uMessage.text = [NSString stringWithFormat:@"%@撤回了一条信息",[Y2WUsers getInstance].getCurrentUser.name];
    [self.session.messages.remote updataMessage:uMessage session:self.session success:^(Y2WBaseMessage *message) {
        
    } failure:^(NSError *error) {
        NSLog(@"revokeMessage : %@",error);
    }];
}




#pragma mark - ———— Y2WAudioPlayerDelegate ———— -

- (void)audioPlayerWillPlay:(Y2WAudioPlayer *)player {
    if (_playAudioIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_playAudioIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)audioPlayerDidStop:(Y2WAudioPlayer *)player {
    NSIndexPath *indexPath = _playAudioIndexPath;
    _playAudioIndexPath = nil;
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)audioPlayer:(Y2WAudioPlayer *)player didFailWithError:(NSError *)error {
    [UIAlertView showTitle:nil message:error.message];
    [self audioPlayerDidStop:player];
}






#pragma mark - ———— getter ———— -

- (Y2WUserConversation *)userConversation {
    if (!_userConversation) {
        _userConversation = [self.session.sessions.user.userConversations getUserConversationWithTargetId:self.session.targetId
                                                                                                     type:self.session.type];
    }
    return _userConversation;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 0, self.view.size.width, self.view.size.height - self.inputView.frame.size.height);
        _tableView.backgroundColor = [UIColor y2w_backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.canCancelContentTouches = NO;
        _tableView.delaysContentTouches = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MessageCell class] forCellReuseIdentifier:NSStringFromClass([MessageCell class])];
        [_tableView registerClass:[MessageNotiCell class] forCellReuseIdentifier:NSStringFromClass([MessageNotiCell class])];
        
        _control = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
        [_control addTarget:self.page action:@selector(loadLastMessage) forControlEvents:UIControlEventValueChanged];
        
        [_tableView addSubview:_control];
    }
    return _tableView;
}

- (InputView *)inputView {
    if (!_inputView) {
        _inputView = [[InputView alloc] initWithFrame:CGRectMake(0, self.view.height - 45, self.view.width, 45)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.UIDelegate = self;
        _inputView.ActionDelegate = self;
        _inputView.MoreDelegate = self;
        
        
        NSMutableArray *items = [NSMutableArray array];
        MoreItem *item = [[MoreItem alloc] init];
        item.title = @"图片";
        item.image = [UIImage y2w_imageNamed:@"输入框-图片"];
        [items addObject:item];
        
        item = [[MoreItem alloc]init];
        item.title = @"拍照";
        item.image = [UIImage y2w_imageNamed:@"输入框-拍照"];
        [items addObject:item];

        item = [[MoreItem alloc] init];
        item.title = @"小视频";
        item.image = [UIImage y2w_imageNamed:@"输入框-小视频"];
        [items addObject:item];

        item = [[MoreItem alloc] init];
        item.title = @"位置";
        item.image = [UIImage y2w_imageNamed:@"输入框-位置"];
        [items addObject:item];

//        if (![[Y2WUsers getInstance].getCurrentUser.role isEqualToString:@"customer"]) {
//            item = [[MoreItem alloc] init];
//            item.title = @"快速任务";
//            item.image = [UIImage y2w_imageNamed:@"功能键盘_快速任务"];
//            [items addObject:item];
//        }
        
        _inputView.moreInputView.items = items;
    }
    return _inputView;
}

@end
