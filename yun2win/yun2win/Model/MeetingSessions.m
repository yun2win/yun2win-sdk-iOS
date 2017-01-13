//
//  MeetingSessions.m
//  yun2win
//
//  Created by duanhl on 16/11/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MeetingSessions.h"

@interface MeetingSessions ()

@property (nonatomic, weak) Y2WSessions *sessions;

@end

@implementation MeetingSessions

//创建会议
+ (NSDictionary *)createDicName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    parameters[@"name"] = name;
    parameters[@"mode"] = @(mode);
    parameters[@"type"] = type;
    parameters[@"startTime"] = startTime;
    parameters[@"endTime"] = endTime;
    parameters[@"remark"] = remark;
    parameters[@"period"] = @(period);
    parameters[@"isClose"] = @(isClose);
    
    return parameters;
}


//// 内存
//- (void)addOrUpdateWithBase:(SessionBase *)base {
//    Y2WSession *session = [self getSessionById:base.ID];
//    if (session) {
//        [session updateWithBase:base];
//        
//    } else {
//        session = [[Y2WSession alloc] initWithSessions:self base:base];
//        [self.list addObject:session];
//    }
//}
//
//- (Y2WSession *)getSessionById:(NSString *)sessionId {
//    NSMutableArray *list = [self.list copy];
//    for (Y2WSession *session in list) {
//        if ([session.ID isEqualToString:sessionId]) {
//            return session;
//        }
//    }
//    
//    SessionBase *base = [SessionBase objectInRealm:self.user.realm forPrimaryKey:sessionId];
//    if (base) {
//        Y2WSession *session = [[Y2WSession alloc] initWithSessions:self base:base];
//        [self.list addObject:session];
//        return session;
//    }
//    
//    return nil;
//}
//
//
////创建会议
//- (void)addMeetingName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure {
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
//    parameters[@"name"] = name ?: @"群";
//    parameters[@"nameChanged"] = name?@"true":@"false";
//    parameters[@"type"] = @"group";
//    parameters[@"secureType"] = @"private";
//    parameters[@"avatarUrl"] = @" ";
//    NSDictionary *extendDic = [MeetingSessions createDicName:name type:type mode:mode startTime:startTime endTime:endTime remark:remark period:period isClose:isClose];
//    parameters[@"extend"] = extendDic.toJsonString;
//    
//    
//    [HttpRequest POSTWithURL:[URL sessions] parameters:parameters success:^(id data) {
//        
//        SessionBase *base = [[SessionBase alloc] initWithValue:data];
//        RLMRealm *realm = self.sessions.user.realm;
//        [realm transactionWithBlock:^{
//            [realm addOrUpdateObject:base];
//        }];
//        [self.sessions addOrUpdateWithBase:base];
//        Y2WSession *session = [self.sessions getSessionById:base.ID];
//        
//        Y2WCurrentUser *currentUser = self.sessions.user;
//        Y2WSessionMember *member = [[Y2WSessionMember alloc] init];
//        member.name = currentUser.name;
//        member.userId = currentUser.ID;
//        member.avatarUrl = currentUser.avatarUrl;
//        member.role = @"master";
//        member.status = @"active";
//        
//        __weak Y2WSession *weakSession = session;
//        [session.members.remote addSessionMembers:@[member] success:^{
//            __strong Y2WSession *strongSession = weakSession;
//            if (success) success(strongSession);
//        } failure:failure];
//    } failure:failure];
//}


@end
