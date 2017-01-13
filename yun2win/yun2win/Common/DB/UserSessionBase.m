//
//  UserSessionBase.m
//  API
//
//  Created by ShingHo on 16/8/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserSessionBase.h"

@implementation UserSessionBase

+ (NSString *)primaryKey {
    return @"ID";
}

- (instancetype)initWithValue:(id)value {
    if (self = [super initWithValue:value]) {
        self.ID        = value[@"id"];
        self.sessionId = value[@"sessionId"];
        self.name      = value[@"name"];
        self.avatarUrl = value[@"avatarUrl"];
        self.createdAt = [value[@"createdAt"] y2w_toDate];
        self.updatedAt = [value[@"updatedAt"] y2w_toDate];
    }
    return self;
}

@end
