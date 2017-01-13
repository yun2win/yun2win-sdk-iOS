//
//  Y2WSessionMember.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSessionMember.h"

@implementation Y2WSessionMember

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members base:(SessionMemberBase *)base {
    if (self = [super init]) {
        _sessionMembers = members;
        _ID             = base.ID;
        _userId         = base.userId;
        [self updateWithBase:base];
    }
    return self;
}

- (void)updateWithBase:(SessionMemberBase *)base {
    _name           = base.name;
    _pinyin         = [base.pinyin componentsSeparatedByString:@","];
    _role           = base.role;
    _status         = base.status;
    _avatarUrl      = base.avatarUrl;
    _createdAt      = base.createdAt.y2w_toString;
    _updatedAt      = base.updatedAt.y2w_toString;
    _lastReadTime   = base.lastReadTime.y2w_toString;
    _time           = base.time;
    _isDelete       = base.isDelete;
    _user           = [[Y2WUsers getInstance] getUserWithSessionMember:self];
}


- (NSString *)getAvatarUrl {
    return _user.avatarUrl;
}





- (NSDictionary *)toDict {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.userId) parameters[@"userId"]       = self.userId;
    if (self.name) parameters[@"name"]           = self.name;
    if (self.avatarUrl) parameters[@"avatarUrl"] = self.avatarUrl;
    if (self.role) parameters[@"role"]           = self.role;
    if (self.status) parameters[@"status"]       = self.status;
    return parameters;
}


@end
