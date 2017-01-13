//
//  Y2WIMBridge.m
//  API
//
//  Created by QS on 16/9/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WIMBridge.h"

NSString * const Y2W_IM_APPT_YPE = @"y2wIMApp";
NSTimeInterval const Y2W_IM_APPT_YPE_MTS = 1264953600000;


@interface Y2WIMBridge ()<Y2WIMClientDelegate>

@property (nonatomic, retain) MulticastDelegate<Y2WIMBridgeDelegate> *delegates;

@property (nonatomic, strong) Y2WIMClient *client;

@property (nonatomic, assign) BOOL reconnecting;

@property (nonatomic, retain) NSTimer *timer;

@end


@implementation Y2WIMBridge

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    
    if (self = [super init]) {
        self.delegates = [[MulticastDelegate<Y2WIMBridgeDelegate> alloc] init];
        self.user = user;
        self.client = [[Y2WIMClient alloc] initWithDelegate:self];
        [self connect];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)addDelegate:(id<Y2WIMBridgeDelegate>)delegate {
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WIMBridgeDelegate>)delegate {
    [self.delegates removeDelegate:delegate];
}

- (void)connect {
    Y2WIMClientConfig *config = [[Y2WIMClientConfig alloc] initWithAppkey:self.user.appKey uid:self.user.ID token:self.user.imToken];
    [self.client connectWithConfig:config];
}

- (void)reconnect {
    if (self.reconnecting == YES) {
        return;
    }
    self.reconnecting = YES;
    [self.user.remote syncIMToken:^(NSError *error) {
        if (self.reconnecting == NO) {
            return;
        }
        self.reconnecting = NO;
        if(error){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reconnect];
            });
            return;
        }
        [self.client reconnectWithToken:self.user.imToken];
    }];
}

- (void)logoutWithMessage:(NSString *)message {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        CurrentUserBase *base = [CurrentUserBase objectForPrimaryKey:self.user.ID];
        [realm deleteObject:base];
    }];
    [self.client closePush];
    [self.client disconnect];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(bridge:didLogoutWithMessage:)]) {
            [self.delegates bridge:self didLogoutWithMessage:message];
        }
    });
}

- (void)sendMessage:(NSDictionary *)message toSession:(IMSession *)session {
    [self.client sendMessage:message toSession:session];
}

- (void)sendMessages:(NSArray<NSDictionary *> *)messages toSession:(IMSession *)session {
    [self sendMessages:messages pushMessage:nil callMessage:nil toSession:session];
}

- (void)sendMessages:(NSArray<NSDictionary *> *)messages pushMessage:(NSDictionary *)pushMessage toSession:(IMSession *)session {
    NSMutableDictionary *messageDict = pushMessage.mutableCopy;
    messageDict[@"sound"] = @"global.wav";
    [self sendMessages:messages pushMessage:messageDict callMessage:nil toSession:session];
}

- (void)sendMessages:(NSArray<NSDictionary *> *)messages pushMessage:(NSDictionary *)pushMessage callMessage:(NSDictionary *)callMessage toSession:(IMSession *)session {
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    if (messages) messageDict[@"syncs"] = messages;
    if (pushMessage) messageDict[@"pns"] = pushMessage;
    if (callMessage) messageDict[@"av"] = callMessage;
    [self.client sendMessage:messageDict toSession:session];
}

- (void)sendOtherDeviceMessages:(NSArray<NSDictionary *> *)messages {
    
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[@"syncs"] = messages ?: @[@{@"type": @(Y2WSyncTypeUserConversation)}];
    [self.user.sessions getSessionWithTargetId:self.user.ID type:@"single" success:^(Y2WSession *session) {
        [self.client sendMessage:messageDict toSession:[[IMSession alloc] initWithSession:session]];

    } failure:^(NSError *error) {
        NSLog(@"%@", error.message);
    }];
}

- (void)syncAllData {
    [self im_client:self.client didReceiveData:@{@"message": @{
                                                         @"syncs": @[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                     @{@"type": @(Y2WSyncTypeContact)},
                                                                     @{@"type": @(Y2WSyncTypeUserSession)}]
                                                         }
                                                 }];
}


#pragma mark - Y2WIMClientDelegate

- (void)im_client:(Y2WIMClient *)client didChangeStatus:(Y2WIMConnectionStatus)status returnCode:(Y2WIMConnectionReturnCode)code {
    switch (status) {
            
        case Y2WIMConnectionStatusDisconnected:
            [self onDisconnectedWithReturnCode:code];
            break;
            
        case Y2WIMConnectionStatusConnected:
            NSLog(@"连接完成");
            [self syncAllData];
            break;
            
        case Y2WIMConnectionStatusConnecting:
        case Y2WIMConnectionStatusReconnecting:
        case Y2WIMConnectionStatusNetworkDisconnected:
            return;
    }
}

- (void)onDisconnectedWithReturnCode:(Y2WIMConnectionReturnCode)code {
    NSLog(@"连接断开: %@",@(code));
    switch (code) {
        case Y2WIMConnectionReturnCodeTokenIsInvalid:
        case Y2WIMConnectionReturnCodeTokenHasExpired:
            [self reconnect];
            break;

        case Y2WIMConnectionReturnCodeKicked:
            [self logoutWithMessage:@"您的账号在其它地方登陆，请重新登录"];
            break;
            
        case Y2WIMConnectionReturnCodeRequestGateError:
        case Y2WIMConnectionReturnCodeUidIsInvalid:
        case Y2WIMConnectionReturnCodeIdentifierRejected:
        case Y2WIMConnectionReturnCodeAuthenticationServerError:
        case Y2WIMConnectionReturnCodeServerInternalError:
        case Y2WIMConnectionReturnCodeServerUnavailable:
        case Y2WIMConnectionReturnCodeUnacceptableProtocolVersion:
        case Y2WIMConnectionReturnCodeAcceptConnect:
//            NSLog(@"code: %@",@(code));
            return;
    }
}

- (void)im_client:(Y2WIMClient *)client didSendUpdateMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session returnCode:(Y2WIMSendReturnCode)code {
    NSLog(@"更新会话: %@",@(code));
    if (code == Y2WIMSendReturnCodeTimeout) {
        [self.client sendUpdateMessage:message toSession:session];
    }
}

- (void)im_client:(Y2WIMClient *)client didSendMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session returnCode:(Y2WIMSendReturnCode)code mts:(NSTimeInterval)mts {
    NSLog(@"发送消息: %@",@(code));

    switch (code) {
        case Y2WIMSendReturnCodeSuccess:
        case Y2WIMSendReturnCodeInvalidFormatOfJSONContent:
        case Y2WIMSendReturnCodeCmdIsInvalid:
        case Y2WIMSendReturnCodeSessionIsInvalid:
        case Y2WIMSendReturnCodeSessionIdIsInvalid:
        case Y2WIMSendReturnCodeSessionMTSIsInvalid:
        case Y2WIMSendReturnCodeSessionMembersIsNull:
        case Y2WIMSendReturnCodeSessionMembersIsInvalid:
            return;
            
        case Y2WIMSendReturnCodeTimeout:
            [self.client sendMessage:message toSession:session];
            break;
            
        case Y2WIMSendReturnCodeSessionMTSOnClientHasExpired:
        {
            NSString *sessionId = [session.ID componentsSeparatedByString:@"_"].lastObject;
            Y2WSession *busiSession = [self.user.sessions getSessionById:sessionId];
            [self.user.sessions.remote getSessionWithTargetId:busiSession.targetId type:busiSession.type success:^(Y2WSession *session) {
                if (busiSession.tryTime > 2){
                    busiSession.tryTime = 0;
                    IMSession *imSession = [[IMSession alloc] initWithSession:busiSession needMembers:YES beginTime:mts force:YES];
                    [self.client sendUpdateMessage:message toSession:imSession];
                }
                else {
                    busiSession.tryTime++;
                    IMSession *imSession = [[IMSession alloc] initWithSession:busiSession needMembers:NO beginTime:mts force:NO];
                    [self.client sendMessage:message toSession:imSession];
                }
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error.message);
            }];
        }   break;
            
        case Y2WIMSendReturnCodeSessionOnServerIsNotExist:
        {
            NSString *sessionType = [session.ID componentsSeparatedByString:@"_"].firstObject;
            NSString *sessionId = [session.ID componentsSeparatedByString:@"_"].lastObject;
            if ([sessionType isEqualToString:Y2W_IM_APPT_YPE]) {
                IMSession *imSession = [[IMSession alloc] initWithY2wIMAppUID:sessionId needMembers:YES];
                [self.client sendUpdateMessage:message toSession:imSession];
            }
            else {
                Y2WSession *busiSession = [self.user.sessions getSessionById:sessionId];
                IMSession *imSession = [[IMSession alloc] initWithSession:busiSession needMembers:YES beginTime:0 force:NO];
                [self.client sendUpdateMessage:message toSession:imSession];
            }
        }   break;
            
        case Y2WIMSendReturnCodeSessionMTSOnServerHasExpired:
        {
            NSString *sessionId = [session.ID componentsSeparatedByString:@"_"].lastObject;
            Y2WSession *busiSession = [self.user.sessions getSessionById:sessionId];
            IMSession *imSession = [[IMSession alloc] initWithSession:busiSession needMembers:YES beginTime:mts force:NO];
            [self.client sendUpdateMessage:message toSession:imSession];
        }   break;
    }
}

- (void)im_client:(Y2WIMClient *)client didReceiveData:(NSDictionary *)data {

    NSDictionary *message = data[@"message"];
    if (![message isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([self.delegates respondsToSelector:@selector(bridge:didReceiveMessage:)]) {
        [self.delegates bridge:self didReceiveMessage:message];
    }
    NSArray *syncs = message[@"syncs"];
    if ([syncs isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in syncs) {
            Y2WSyncType type = [dict[@"type"] integerValue];
            switch (type) {
                case Y2WSyncTypeUserConversation:
                {
                    [self.user.userConversations.remote sync:nil];
                }   break;
                    
                case Y2WSyncTypeMessage:
                {
                    NSString *sessionId = [dict[@"sessionId"] componentsSeparatedByString:@"_"].lastObject;
                    Y2WSession *session = [self.user.sessions getSessionById:sessionId];
                    [session.messages.remote sync];
                }   break;
                    
                case Y2WSyncTypeContact:
                    [self.user.contacts.remote sync:nil];
                    break;
                    
                case Y2WSyncTypeUserSession:
//                    [self.user.userSessions.remote sync];
                    break;
                    
                case Y2WSyncTypeSessionMember:
                {
                    NSString *sessionId = [dict[@"sessionId"] componentsSeparatedByString:@"_"].lastObject;
                    Y2WSession *session = [self.user.sessions getSessionById:sessionId];
                    [session.members.remote sync:nil];
                }   break;
            }
        }
    }
}

- (void)im_client:(Y2WIMClient *)client didChangeOnlineStatus:(BOOL)isOnline {
    if ([self.delegates respondsToSelector:@selector(bridge:didChangeOnlineStatus:)]) {
        [self.delegates bridge:self didChangeOnlineStatus:isOnline];
    }
    
    if (isOnline) {
        [self applicationDidBecomeActive:nil];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self syncAllData];
    if (self.reconnecting) {
        self.reconnecting = NO;
        [self reconnect];
    }
}

@end

