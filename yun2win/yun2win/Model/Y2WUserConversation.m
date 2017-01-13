//
//  Y2WUserConversation.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WUserConversation.h"
#import "Y2WSession.h"

@implementation Y2WUserConversation

- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations
                                     base:(UserConversationBase *)base {
    if (self = [super init]) {
        _userConversations  = userConversations;
        _ID         = base.ID;
        [self updateWithBase:base];
    }
    return self;
}

- (void)updateWithBase:(UserConversationBase *)base {
    _name       = base.name;
    _type       = base.type;
    _avatarUrl  = base.avatarUrl;
    _targetId   = base.targetId;
    _isDelete   = base.isDelete;
    _createdAt  = base.createdAt.y2w_toString;
    _updatedAt  = base.updatedAt.y2w_toString;
    _visiable   = base.visiable;
    _unRead     = base.unread;
    _top        = base.top;
    _text       = base.text;
    _draft      = base.draft;
    _subType    = base.subType;
}



- (NSString *)getName {
    if ([self.type isEqualToString:@"p2p"]) {
        Y2WContact *contact = [self.userConversations.user.contacts getContactWithUID:self.targetId];
        return contact.getName ?: self.name;
        
    } else {
        return self.name;
    }
}

- (NSString *)getAvatarUrl {
    if ([self.type isEqualToString:@"p2p"]) {
        Y2WContact *contact = [self.userConversations.user.contacts getContactWithUID:self.targetId];
        return contact.getAvatarUrl ?: self.avatarUrl;
    }
    
    return self.avatarUrl;
}


- (void)getSessionDidCompletion:(void (^)(Y2WSession *, NSError *))block {
    if (!block) return;

    [self.userConversations.user.sessions getSessionWithTargetId:self.targetId type:self.type success:^(Y2WSession *session) {
        block(session,nil);
        
    } failure:^(NSError *error) {
        block(nil,error);
    }];
}




- (void)clearUnRead {
    RLMRealm *realm = self.userConversations.user.realm;
    [realm transactionWithBlock:^{
        UserConversationBase *base = [UserConversationBase objectInRealm:realm forPrimaryKey:self.ID];
        base.unread = 0;
    }];
    self.unRead = 0;
}








- (void)setUnRead:(NSInteger)unRead {
    _unRead = unRead;
    RLMRealm *realm = self.userConversations.user.realm;
    [realm transactionWithBlock:^{
        UserConversationBase *base = [UserConversationBase objectInRealm:realm forPrimaryKey:self.ID];
        base.unread = (int)unRead;
    }];
}

- (void)setDraft:(NSString *)draft {
    _draft = draft.copy;
    RLMRealm *realm = self.userConversations.user.realm;
    [realm transactionWithBlock:^{
        UserConversationBase *base = [UserConversationBase objectInRealm:realm forPrimaryKey:self.ID];
        base.draft = draft.copy;
    }];
}



- (NSDictionary *)toParameters {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"targetId"]  = self.targetId;
    parameters[@"avatarUrl"] = self.avatarUrl;
    parameters[@"name"]      = self.name;
    parameters[@"type"]      = self.type;
    parameters[@"top"]       = @(self.top);
    return parameters;
}

@end
