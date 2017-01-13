//
//  Y2WContact.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WContact.h"

@implementation Y2WContact

- (instancetype)initWithContacts:(Y2WContacts *)contacts base:(ContactBase *)base {
    if (self = [super init]) {
        _contacts       = contacts;
        _ID             = base.ID;
        _userId         = base.userId;
        [self updateWithBase:base];
    }
    return self;
}

- (void)updateWithBase:(ContactBase *)base {
    _name        = base.name;
    _pinyin      = [base.pinyin componentsSeparatedByString:@","];
    _title       = base.title;
    _titlePinyin = [base.titlePinyin componentsSeparatedByString:@","];
    _remark      = base.remark;
    _avatarUrl   = base.avatarUrl;
    _createdAt   = base.createdAt.y2w_toString;
    _updatedAt   = base.updatedAt.y2w_toString;
    _isDelete    = base.isDelete;
    _user        = [[Y2WUsers getInstance] getUserWithContact:self];
    _type        = base.type;
    _extend      = base.extend.parseJsonString;
}



- (NSString *)getName {
    if (self.title.length && ![self.title isEqualToString:@" "]) {
        return self.title;
    }
    return self.user.name;
}

- (NSString *)getAvatarUrl {
    if (_user) {
        return _user.avatarUrl;
    }
    return _avatarUrl;
}



- (Y2WUserConversation *)getUserConversation {
    NSArray *userConversations = [self.contacts.user.userConversations getUserConversations];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type LIKE[cd] %@ AND targetId LIKE[cd] %@",@"p2p",self.userId];
    return [userConversations filteredArrayUsingPredicate:predicate].firstObject;
}


- (void)getSessionDidCompletion:(void (^)(Y2WSession *, NSError *))block {
    if (!block) return;
    [self.contacts.user.sessions getSessionWithTargetId:self.userId type:@"p2p" success:^(Y2WSession *session) {
        block(session,nil);
        
    } failure:^(NSError *error) {
        block(nil,error);
    }];
}

@end
