//
//  SessionBase.m
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SessionBase.h"

@implementation SessionBase

+ (NSString *)primaryKey {
    return @"ID";
}

- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _ID           = value[@"id"];
        _name         = value[@"name"];
        _type         = value[@"type"];
        _secureType   = value[@"secureType"];
        _avatarUrl    = value[@"avatarUrl"];
        _descriptions = value[@"description"];
        _nameChanged  = [value[@"nameChanged"] boolValue];
        
        _createdAt    = [value[@"createdAt"] y2w_toDate];
        _updatedAt    = [value[@"updatedAt"] y2w_toDate];
        _extend       = value[@"extend"];
        
        if ([self.type isEqualToString:@"group"]) {
            _targetId = _ID;
        }
    }
    return self;
}


@end
