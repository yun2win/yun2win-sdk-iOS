//
//  Y2WBaseMessage.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBaseMessage.h"
#import "Y2WTextMessage.h"
#import "Y2WImageMessage.h"
#import "Y2WFileMessage.h"
#import "Y2WVideoMessage.h"
#import "Y2WLocationMessage.h"
#import "Y2WSystemMessage.h"
#import "Y2WAudioMessage.h"
#import "Y2WAVMessage.h"

@implementation Y2WBaseMessage

+ (instancetype)createMessageWithDict:(NSDictionary *)dict
{
    if ([dict[@"type"] isEqualToString:@"text"] || [dict[@"type"] isEqualToString:@"task"]) {
        return [[Y2WTextMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"image"])
    {
        return [[Y2WImageMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"file"])
    {
        return [[Y2WFileMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"video"] || [dict[@"type"] isEqualToString:@"movie"])
    {
        return [[Y2WVideoMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"system"])
    {
        return [[Y2WSystemMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"location"])
    {
        return [[Y2WLocationMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"audio"])
    {
        return [[Y2WAudioMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"av"])
    {
        return [[Y2WAVMessage alloc] initWithValue:dict];
    }
    return [[Y2WSystemMessage alloc] initWithValue:dict];
}

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        [self updateWithDict:value];
    }
    return self;
}


- (void)updateWithDict:(NSDictionary *)dict {
    _ID         = dict[@"id"];
    _sender     = dict[@"sender"];
    _type       = dict[@"type"];
    _createdAt  = dict[@"createdAt"];
    _updatedAt  = dict[@"updatedAt"];
    _isShowTimestamp = [dict[@"isShowTimestamp"] boolValue];
    _status     = dict[@"status"];
    _sessionId  = dict[@"sessionId"];

    {// 解析消息内容
        id content = dict[@"content"];
        if ([content isKindOfClass:[NSString class]]) {
            content = [dict[@"content"] parseJsonString];
        }
        
        if ([content isKindOfClass:[NSDictionary class]]) {
            self.content = content;
            
        }else if ([content isKindOfClass:[NSString class]]) {
            self.content = @{@"text": content};
            
        }else {
            self.content = @{@"text": dict[@"content"]};
        }
        self.text = self.content[@"text"];
    }
    
    {// 判断是否被@了
        NSArray *users = self.content[@"users"];
        self.users = users;
        if (users.count) {
            for (NSDictionary *userDict in users) {
                if ([userDict[@"id"] isEqualToString:[Y2WUsers getInstance].getCurrentUser.ID]) {
                    self.byTheAt = YES;
                    break;
                }
            }
        }
    }
}






- (BOOL)isUploadFile {
    NSString *type = self.type;
    if ([type isEqualToString:@"image"] ||
        [type isEqualToString:@"video"] ||
        [type isEqualToString:@"audio"] ||
        [type isEqualToString:@"file"]  ||
        [type isEqualToString:@"location"]) {
        
        if (self.content[@"src"]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
