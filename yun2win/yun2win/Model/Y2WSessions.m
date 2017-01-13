//
//  Y2WSessions.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSessions.h"
#import "SessionBase.h"

@interface Y2WSessions()

@property (nonatomic, retain) NSMutableArray *list;

@end


@implementation Y2WSessions

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser {
    if (self = [super init]) {
        self.list = [NSMutableArray array];
        self.user = currentUser;
        self.remote = [[Y2WSessionsRemote alloc] initWithSessions:self];
    }
    return self;
}



// 内存
- (void)addOrUpdateWithBase:(SessionBase *)base {
    Y2WSession *session = [self getSessionById:base.ID];
    if (session) {
        [session updateWithBase:base];
        
    } else {
        session = [[Y2WSession alloc] initWithSessions:self base:base];
        [self.list addObject:session];
    }
}



- (Y2WSession *)getSessionById:(NSString *)sessionId {
    NSMutableArray *list = [self.list copy];
    for (Y2WSession *session in list) {
        if ([session.ID isEqualToString:sessionId]) {
            return session;
        }
    }
    
    SessionBase *base = [SessionBase objectInRealm:self.user.realm forPrimaryKey:sessionId];
    if (base) {
        Y2WSession *session = [[Y2WSession alloc] initWithSessions:self base:base];
        [self.list addObject:session];
        return session;
    }
    
    return nil;
}


- (Y2WSession *)getSessionByTargetId:(NSString *)targetId type:(NSString *)type {
    NSPointerArray *list = [self.list copy];
    for (Y2WSession *session in list) {
        if ([session.targetId isEqualToString:targetId] && [session.type isEqualToString:type]) {
            return session;
        }
    }
    
    SessionBase *base = [SessionBase objectsInRealm:self.user.realm where:@"targetId == %@ AND type == %@", targetId, type].firstObject;
    if (base) {
        Y2WSession *session = [[Y2WSession alloc] initWithSessions:self base:base];
        [self.list addObject:session];
        return session;
    }
    
    return nil;
}


- (void)getSessionWithTargetId:(NSString *)targetId type:(NSString *)type success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure {
    if (!success) return;
    
    Y2WSession *session = [self getSessionByTargetId:targetId type:type];
    if (session) return success(session);
    
    [self.remote getSessionWithTargetId:targetId type:type success:success failure:failure];
}

@end









@interface Y2WSessionsRemote ()


@end


@implementation Y2WSessionsRemote

- (instancetype)initWithSessions:(Y2WSessions *)sessions {
    if (self = [super init]) {
        self.sessions = sessions;
    }
    return self;
}

- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                       success:(void (^)(Y2WSession *))success
                       failure:(void (^)(NSError *))failure {
    [self getSessionWithTargetId:targetId type:type extend:nil success:success failure:failure];
}

- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                        extend:(NSString *)extend
                       success:(void (^)(Y2WSession *))success
                       failure:(void (^)(NSError *))failure {
    
    NSString *url = [self urlWithTargetId:targetId type:type extend:extend];
    [HttpRequest GETWithURL:url parameters:nil success:^(id data) {
        SessionBase *base = [[SessionBase alloc] initWithValue:data];
        base.targetId = targetId;
        RLMRealm *realm = self.sessions.user.realm;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:base];
        }];
        
        [self.sessions addOrUpdateWithBase:base];
        Y2WSession *session = [self.sessions getSessionById:base.ID];
        
        [session.members.remote sync:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(session);
                }
            });
        }];
    } failure:failure];
}


- (void)updateSession:(Y2WSession *)session
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (session.name) parameters[@"name"] = session.name;
    if (session.type) parameters[@"type"] = session.type;
    if (session.avatarUrl) parameters[@"avatarUrl"] = session.avatarUrl;
    if (session.nameChanged) parameters[@"nameChanged"] = @(session.nameChanged);
    if (session.extend) parameters[@"extend"] = session.extend.toJsonString;

    [HttpRequest PUTWithURL:[URL aboutSession:session.ID] parameters:parameters success:^(id data) {
        
        SessionBase *base = [[SessionBase alloc] initWithValue:data];
        RLMRealm *realm = self.sessions.user.realm;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:base];
        }];
        [self.sessions addOrUpdateWithBase:base];
        Y2WSession *session = [self.sessions getSessionById:base.ID];
        
        Y2WUserConversation *conversation = [self.sessions.user.userConversations getUserConversationWithTargetId:session.targetId type:session.type];
        conversation.name = session.name;
        conversation.avatarUrl = session.avatarUrl;
        
        [self.sessions.user.userConversations.remote updateUserConversation:conversation success:success failure:failure];
    } failure:failure];
}


- (void)addWithName:(NSString *)name
               type:(NSString *)type
         secureType:(NSString *)secureType
          avatarUrl:(NSString *)avatarUrl
            success:(void (^)(Y2WSession *))success
            failure:(void (^)(NSError *))failure {
    
    [self addWithName:name type:type secureType:secureType avatarUrl:avatarUrl role:@"master" extend:nil success:success failure:failure];
}


- (void)addWithName:(NSString *)name type:(NSString *)type secureType:(NSString *)secureType avatarUrl:(NSString *)avatarUrl role:(NSString *)role extend:(NSDictionary *)extend success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = name ?: @"群";
    parameters[@"nameChanged"] = name?@"true":@"false";
    parameters[@"type"] = type;
    parameters[@"secureType"] = secureType;
    parameters[@"avatarUrl"] = avatarUrl ?: @"";
    if ([extend isKindOfClass:[NSDictionary class]]) {
        parameters[@"extend"] = extend.toJsonString;
    }
    
    [HttpRequest POSTWithURL:[URL sessions] parameters:parameters success:^(id data) {
        
        SessionBase *base = [[SessionBase alloc] initWithValue:data];
        RLMRealm *realm = self.sessions.user.realm;
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject:base];
        }];
        [self.sessions addOrUpdateWithBase:base];
        Y2WSession *session = [self.sessions getSessionById:base.ID];
        
        Y2WCurrentUser *currentUser = self.sessions.user;
        Y2WSessionMember *member = [[Y2WSessionMember alloc] init];
        member.name = currentUser.name;
        member.userId = currentUser.ID;
        member.avatarUrl = currentUser.avatarUrl;
        member.role = role;
        member.status = @"active";
        
        __weak Y2WSession *weakSession = session;
        [session.members.remote addSessionMembers:@[member] success:^{
            __strong Y2WSession *strongSession = weakSession;
            if (success) success(strongSession);
        } failure:failure];
    } failure:failure];
}


#pragma mark - ———— Helper ———— -

- (NSString *)urlWithTargetId:(NSString *)targetId type:(NSString *)type extend:(NSString *)extend {
    if ([type isEqualToString:@"single"]) {
        return [URL singleSession];

    }else if ([type isEqualToString:@"p2p"]) {
        return [URL p2pSessionWithUserA:self.sessions.user.ID andUserB:targetId extend:extend];
    }
    return [URL aboutSession:targetId];
}

@end
