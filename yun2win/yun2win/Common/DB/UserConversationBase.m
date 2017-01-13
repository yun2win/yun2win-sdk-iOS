//
//  UserConversationBase.m
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserConversationBase.h"

@implementation UserConversationBase

+ (NSString *)primaryKey {
    return @"ID";
}

+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withValue:(id)value {
    NSMutableDictionary *dict = [value mutableCopy];
    dict[@"ID"] = value[@"id"];
    dict[@"createdAt"] = [value[@"createdAt"] y2w_toDate];
    dict[@"updatedAt"] = [value[@"updatedAt"] y2w_toDate];
    dict[@"isDelete"] = @([value[@"isDelete"] boolValue]);
    dict[@"visiable"] = @([value[@"visiable"] boolValue]);
    dict[@"top"] = @([value[@"top"] boolValue]);
    dict[@"unread"] = @([value[@"unread"] intValue]);
    dict[@"hidden"] = @(NO);
    dict[@"avatarUrl"] = value[@"avatarUrl"];
    
    if ([value[@"extend"] length]) {
        dict[@"subType"] = [value[@"extend"] parseJsonString][@"type"];
    }
    else {
        [dict removeObjectForKey:@"extend"];
    };

    {// 解析消息体
        NSDictionary *messageDict = value[@"lastMessage"];
        if (messageDict) {
            Y2WBaseMessage *message = [Y2WBaseMessage createMessageWithDict:messageDict];
            NSString *text = message.text;
            Y2WUser *user = [[Y2WUsers getInstance] getUserById:message.sender];
            if (user) {
                text = [user.name stringByAppendingFormat:@": %@",text];
            }
            dict[@"text"] = text;
        }
    }
 
    UserConversationBase *base = [super createOrUpdateInRealm:realm withValue:dict];
    if ([base.subType isEqualToString:@"conference"]) {
//        base.unread = 0;
        base.avatarUrl = @"attachments/4602/H9dI5H9UdIWmhlWb";
        base.hidden = YES;
        dict[@"ID"] = @"conference";
        dict[@"name"] = @"我的会议";
        [dict removeObjectForKey:@"targetId"];
        [dict removeObjectForKey:@"extend"];
        [dict removeObjectForKey:@"subType"];
        RLMResults *results = [UserConversationBase objectsInRealm:realm where:@"isDelete == %d AND hidden == %d AND unread > 0", NO, YES];
        dict[@"unread"] = @(results.count);
        [super createOrUpdateInRealm:realm withValue:dict];
        
    }
    
    return base;
}

@end
