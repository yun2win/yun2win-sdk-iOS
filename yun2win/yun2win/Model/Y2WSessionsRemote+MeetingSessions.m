//
//  Y2WSessionsRemote+MeetingSessions.m
//  yun2win
//
//  Created by duanhl on 16/11/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSessionsRemote+MeetingSessions.h"

@implementation Y2WSessionsRemote (MeetingSessions)

+ (id)setupObj:(id)obj1 defaultObj:(id)obj2 {
    return obj1 ? obj1 : obj2;
}

//创建会议
+ (NSDictionary *)createDicName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    parameters[@"name"] = [Y2WSessionsRemote setupObj:name defaultObj:@""];
    parameters[@"mode"] = @(mode);
    parameters[@"type"] = [Y2WSessionsRemote setupObj:type defaultObj:@""];
    parameters[@"remark"] = [Y2WSessionsRemote setupObj:remark defaultObj:@""];
    parameters[@"period"] = @(period);
    parameters[@"isClose"] = @(isClose);
    parameters[@"startTime"] = [Y2WSessionsRemote setupObj:startTime defaultObj:@""];
    parameters[@"endTime"] = [Y2WSessionsRemote setupObj:endTime defaultObj:@""];
    return parameters;
}

//添加成员
- (void)addMeetingUser:(NSArray *)userArray enter:(BOOL)enter session:(Y2WSession *)session success:(void (^)(void))success failure:(void (^)(NSError *))failure{
    // 创建成功准备添加成员
    // 构建需要添加的成员对象
    NSMutableArray *sessionMembers = [NSMutableArray array];
    for (Y2WSessionMember *tempMember in userArray) {
        if ([tempMember.userId isEqualToString:self.sessions.user.ID]) { continue;}
        
        Y2WSessionMember *sessionMember = [[Y2WSessionMember alloc] init];
        sessionMember.name = tempMember.name;
        sessionMember.userId = tempMember.userId;
        sessionMember.avatarUrl = tempMember.avatarUrl;
        sessionMember.role = @"user";
        sessionMember.status = @"active";
        sessionMember.extend = @{@"enter":@(enter)};
        [sessionMembers addObject:sessionMember];
    }
    
//    __weak typeof(session) weakSession2 = session;
    // 添加成员
    [session.members.remote addSessionMembers:sessionMembers success:^{
//        __strong typeof(session) strongSession = weakSession2;
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        [UIAlertView showTitle:nil message:error.message];
    }];
}


//创建会议
- (void)addMeetingName:(NSString *)name mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose userArray:(NSArray *)userArray success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    parameters[@"name"] = name ?: @"群";
    parameters[@"nameChanged"] = name?@"true":@"false";
    parameters[@"type"] = @"group";
    parameters[@"secureType"] = @"private";
    parameters[@"avatarUrl"] = @" ";
    NSDictionary *extendDic = [Y2WSessionsRemote createDicName:name type:@"conference" mode:mode startTime:startTime endTime:endTime remark:remark period:period isClose:isClose];
    parameters[@"extend"] = extendDic.toJsonString;
    
    
    [HttpRequest POSTWithURL:[URL sessions]
                  parameters:parameters
                     success:^(id data) {
        
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
        member.role = @"master;speaker";
        member.status = @"active";
        member.extend = @{@"enter":@(NO)};
        
        __weak Y2WSession *weakSession = session;
             [session.members.remote addSessionMembers:@[member] success:^{
                 __strong Y2WSession *strongSession = weakSession;
                 
                 //添加其它成员
                 [self addMeetingUser:userArray enter:NO session:weakSession success:^{
                     [weakSession.sessions.user.userConversations.remote sync:^{
                         if (success) success(strongSession);
                     }];

                 } failure:failure];
                 
             } failure:failure];

    } failure:failure];
}

//获取会议列表
- (NSArray *)getMeetingList {
    RLMResults *results = [[UserConversationBase objectsInRealm:self.sessions.user.realm where:@"isDelete == %d AND subType == %@", NO, @"conference"]
                           sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"top" ascending:NO],
                                                           [RLMSortDescriptor sortDescriptorWithProperty:@"createdAt" ascending:NO]]];
    
    NSMutableArray *list = [NSMutableArray array];
    for (UserConversationBase *base in results) {
        Y2WUserConversation *userConversation = [[Y2WUserConversation alloc] initWithUserConversations:self.sessions.user.userConversations base:base];
        [list addObject:userConversation];
    }
    
    return [list copy];
}

@end
