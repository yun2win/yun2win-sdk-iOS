//
//  SessionMemberBase.m
//  API
//
//  Created by ShingHo on 16/8/28.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SessionMemberBase.h"

@implementation SessionMemberBase

+ (NSString *)primaryKey {
    return @"ID";
}

- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _ID        = value[@"id"];
        _userId    = value[@"userId"];
        _name      = value[@"name"];
        _pinyin    = [value[@"pinyin"] componentsJoinedByString:@","];
        _role      = value[@"role"];
        _status    = value[@"status"];
        _avatarUrl = value[@"avatarUrl"];
        _createdAt = [value[@"createdAt"] y2w_toDate];
        _updatedAt = [value[@"updatedAt"] y2w_toDate];
        _lastReadTime = [value[@"lastReadTime"] y2w_toDate];
        _time      = [value[@"time"] intValue];
        _isDelete  = [value[@"isDelete"] boolValue];
        _extend    = value[@"extend"];
    }
    return self;
}

@end
