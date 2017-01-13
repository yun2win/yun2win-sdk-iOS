//
//  Y2WSession.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSession.h"

@implementation Y2WSession

- (instancetype)initWithSessions:(Y2WSessions *)sessions base:(SessionBase *)base {
    self = [super init];
    if (self) {
        _sessions  = sessions;
        [self updateWithBase:base];
        _members = [[Y2WSessionMembers alloc] initWithSession:self];
        _messages = [[Y2WMessages alloc] initWithSession:self];
    }
    return self;
}

- (void)updateWithBase:(SessionBase *)base {
    _targetId   = base.targetId;
    _ID         = base.ID;
    _type       = base.type;
    _name       = base.name;
    _avatarUrl  = base.avatarUrl;
    _secureType = base.secureType;
    _descriptions = base.descriptions;
    _createdAt  = base.createdAt.y2w_toString;
    _updatedAt  = base.updatedAt.y2w_toString;
    _extend     = [base.extend parseJsonString];
    _nameChanged = base.nameChanged;
}

- (void)setName:(NSString *)name {
    _name = name.copy;
    _nameChanged = YES;
}


- (NSString *)getName {
    if ([self.type isEqualToString:@"p2p"]) {
        Y2WContact *contact = [self.sessions.user.contacts getContactWithUID:self.targetId];
        return contact.getName ?: self.name;
        
    } else {
        return self.name;
    }
}

- (NSString *)getAvatarUrl {
    if ([self.type isEqualToString:@"p2p"]) {
        Y2WContact *contact = [self.sessions.user.contacts getContactWithUID:self.targetId];
        return contact.getAvatarUrl ?: self.avatarUrl;
    }
    
    return self.avatarUrl;
}




- (Y2WUserConversation *)userConversation {
    return [self.sessions.user.userConversations getUserConversationWithTargetId:self.targetId type:self.type];
}

@end
