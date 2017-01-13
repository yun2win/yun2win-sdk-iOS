//
//  ContactBase.m
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ContactBase.h"

@implementation ContactBase

+ (NSString *)primaryKey {
    return @"ID";
}

- (instancetype)initWithValue:(id)value {
    if (self = [super init]) {
        _ID          = value[@"id"];
        _userId      = value[@"userId"];
        _name        = value[@"name"];
        _pinyin      = [value[@"pinyin"] componentsJoinedByString:@","];
        _title       = value[@"title"];
        _titlePinyin = [value[@"titlePinyin"] componentsJoinedByString:@","];
        _remark      = value[@"remark"];
        _avatarUrl   = value[@"avatarUrl"];
        _createdAt   = [value[@"createdAt"] y2w_toDate];
        _updatedAt   = [value[@"updatedAt"] y2w_toDate];
        _isDelete    = [value[@"isDelete"] boolValue];
        
        if ([value[@"extend"] isKindOfClass:[NSString class]]) {
            _extend = value[@"extend"];
            NSDictionary *extend = [_extend parseJsonString];
            if ([extend isKindOfClass:[NSDictionary class]]) {
                _type = extend[@"type"];
            }
        }
    }
    return self;
}

@end
