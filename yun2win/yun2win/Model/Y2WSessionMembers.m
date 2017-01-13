//
//  Y2WSessionMembers.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSessionMembers.h"
#import "Y2WSession.h"
#import "MulticastDelegate.h"
#import "Y2WSyncManager.h"

@interface Y2WSessionMembers ()

@property (nonatomic, retain) MulticastDelegate<Y2WSessionMembersDelegate> *delegates;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) NSArray *alllist;

@end

@implementation Y2WSessionMembers

- (instancetype)initWithSession:(Y2WSession *)session {
    if (self = [super init]) {
        _session = session;
        _delegates = [[MulticastDelegate<Y2WSessionMembersDelegate> alloc] init];
        [self update];
        _remote = [[Y2WSessionMembersRemote alloc] initWithSessionMembers:self];
    }
    return self;
}


- (void)update {
    RLMRealm *realm = self.session.sessions.user.realm;
    RLMResults *resluts = [SessionMemberBase objectsInRealm:realm where:@"sessionId == %@ AND isDelete == %d AND status == 'active'",self.session.ID, NO];
    
    NSMutableArray *list = [NSMutableArray array];
    for (SessionMemberBase *base in resluts) {
        Y2WSessionMember *member = [self getMemberWithUserId:base.userId];
        if (member) {
            [member updateWithBase:base];
            
        }else {
            member = [[Y2WSessionMember alloc] initWithSessionMembers:self base:base];
        }
        [list addObject:member];
    }
    
    self.list = list;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(sessionMembersDidChangeContent:)]) {
            [self.delegates sessionMembersDidChangeContent:self];
        }
    });
    [self updateAll];
}

- (void)updateAll {
    RLMRealm *realm = self.session.sessions.user.realm;
    RLMResults *resluts = [SessionMemberBase objectsInRealm:realm where:@"sessionId == %@",self.session.ID];
    self.session.createMTS = [[resluts sortedResultsUsingProperty:@"createdAt" ascending:YES].lastObject createdAt].y2w_toString;
    self.session.updateMTS = [[resluts sortedResultsUsingProperty:@"updatedAt" ascending:YES].lastObject updatedAt].y2w_toString;

    NSMutableArray *list = [NSMutableArray array];
    
    for (SessionMemberBase *base in resluts) {
        Y2WSessionMember *member = [self getMemberFromAllWithUserId:base.userId];
        if (member) {
            [member updateWithBase:base];
            
        }else {
            member = [[Y2WSessionMember alloc] initWithSessionMembers:self base:base];
        }
        [list addObject:member];
    }
    self.alllist = list;
}



#pragma mark - ———— Y2WsessionMembersDelegateInterface ———— -

- (void)addDelegate:(id<Y2WSessionMembersDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WSessionMembersDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}





- (Y2WSessionMember *)getMemberWithUserId:(NSString *)userId {
    NSArray *list = self.list.copy;
    for (Y2WSessionMember *member in list) {
        if ([member.userId isEqualToString:userId]) {
            return member;
        }
    }
   return nil;
}

- (NSArray *)getMembers {
    return self.list.copy;
}




- (Y2WSessionMember *)getMemberFromAllWithUserId:(NSString *)userId {
    NSArray *list = self.alllist.copy;
    for (Y2WSessionMember *member in list) {
        if ([member.userId isEqualToString:userId]) {
            return member;
        }
    }
    return nil;
}

- (NSArray *)getAllMembers {
    return self.alllist.copy;
}

@end








@interface Y2WSessionMembersRemote ()<Y2WSyncManagerDelegate>

@property (nonatomic, weak) Y2WSessionMembers *members;

@property (nonatomic, retain) Y2WSyncManager *syncManager;

@end


@implementation Y2WSessionMembersRemote

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members {
    if (self = [super init]) {
        self.members = members;
        self.syncManager = [[Y2WSyncManager alloc] initWithDelegate:self
                                                        currentUser:self.members.session.sessions.user
                                                                url:[URL sessionMembersWithSessionId:self.members.session.ID]];
    }
    return self;
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncFirstForData:(NSDictionary *)data onError:(NSError *)error {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncForData:(NSDictionary *)data {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncOnceForDatas:(NSArray *)datas {
    RLMArray *members = [[RLMArray alloc] initWithObjectClassName:[SessionMemberBase className]];
    for (NSDictionary *data in datas) {
        SessionMemberBase *member = [[SessionMemberBase alloc] initWithValue:data];
        member.sessionId = self.members.session.ID;
        [members addObject:member];
    }
    RLMRealm *realm = self.members.session.sessions.user.realm;
    [realm transactionWithBlock:^{
        [realm addOrUpdateObjectsFromArray:members];
    }];
    [self.members update];
}



- (void)sync:(dispatch_block_t)block {
    [self.syncManager sync:block];
}


// 添加一个成员
- (void)addSessionMember:(Y2WSessionMember *)member
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = member.name;
    parameters[@"userId"] = member.userId;
    parameters[@"role"] = member.role;
    parameters[@"status"] = member.status;
    parameters[@"avatarUrl"] = member.avatarUrl;
    if (member.extend) {
        parameters[@"extend"] = member.extend.toJsonString;
    }

    [HttpRequest POSTWithURL:[URL sessionMembersWithSessionId:self.members.session.ID] parameters:parameters success:^(id data) {
        NSLog(@"%@--%@", member.name, parameters);

        // 同步成员放到添加多个成员内
        if (success) success();
    } failure:^(NSError *error) {
        NSLog(@"%@--%@--%@",error.message, member.name, parameters);
        failure(error);
    }];
}

// 添加多个成员
- (void)addSessionMembers:(NSArray<Y2WSessionMember *> *)members
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
        __block NSError *failureError = nil;
        
        for (Y2WSessionMember *member in members) {
            
            [self addSessionMember:member success:^{
                dispatch_semaphore_signal(dispatchSemaphore);
                
            } failure:^(NSError *error) {
                failureError = error;
                dispatch_semaphore_signal(dispatchSemaphore);
            }];
            
            dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
            
            if (failureError) {
                if (failure) failure(failureError);
                return;
            }
        }
        
        // 同步消息
        [self.members.session.messages.remote sync];
        // 同步用户会话
        [self.members.session.sessions.user.userConversations.remote sync:^{
            
            [self sync:^{
                IMSession *imSession = [[IMSession alloc] initWithSession:self.members.session];
                [self.members.session.sessions.user.bridge sendMessages:@[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                          @{@"type": @(Y2WSyncTypeMessage), @"sessionId": imSession.ID}]
                                                              toSession:imSession];
                dispatch_async(dispatch_get_main_queue(), success);
            }];
        }];
    });
}

// 使用邮件邀请一个成员
- (void)inviteSessionMemberWithEmail:(NSString *)email
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *))failure {
    
    [HttpRequest POSTWithURL:[URL sessionMembersInviteWithSessionId:self.members.session.ID] parameters:@{@"email": email} success:^(id data) {
        
        // 同步消息
        [self.members.session.messages.remote sync];

        // 同步用户会话
        [self.members.session.sessions.user.userConversations.remote sync:^{
            [self sync:^{
                IMSession *imSession = [[IMSession alloc] initWithSession:self.members.session];
                [self.members.session.sessions.user.bridge sendMessages:@[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                          @{@"type": @(Y2WSyncTypeMessage), @"sessionId": imSession.ID}]
                                                              toSession:imSession];
                dispatch_async(dispatch_get_main_queue(), success);
            }];
            if (success) success();
        }];
       
    } failure:failure];
}



- (void)deleteSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure {
    
    [HttpRequest DELETEWithURL:[URL singleSessionMember:member.ID
                                                Session:self.members.session.ID]
                    parameters:nil
                       success:^(id data) {
                           // 同步消息
                           [self.members.session.messages.remote sync];
                           // 同步用户会话
                           [self.members.session.sessions.user.userConversations.remote sync:^{
                               // 同步成员
                               [self sync:nil];
                               
                               IMSession *imSession = [[IMSession alloc] initWithSession:self.members.session];
                               [self.members.session.sessions.user.bridge sendMessages:@[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                                         @{@"type": @(Y2WSyncTypeMessage), @"sessionId": imSession.ID}]
                                                                             toSession:imSession];
                               if (success) success();
                           }];
    } failure:failure];
}

- (void)updateSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure {
    
    [HttpRequest PUTWithURL:[URL singleSessionMember:member.ID
                                             Session:self.members.session.ID]
                 parameters:[member toDict]
                    success:^(id data) {
                        
                        // 同步消息
                        [self.members.session.messages.remote sync];
                        // 同步用户会话
                        [self.members.session.sessions.user.userConversations.remote sync:^{
                            // 同步成员
                            [self sync:nil];
                            
                            IMSession *imSession = [[IMSession alloc] initWithSession:self.members.session];
                            [self.members.session.sessions.user.bridge sendMessages:@[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                                      @{@"type": @(Y2WSyncTypeMessage), @"sessionId": imSession.ID}]
                                                                          toSession:imSession];
                            if (success) success();
                        }];
    } failure:failure];
}

@end
