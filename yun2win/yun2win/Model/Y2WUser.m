//
//  Y2WUser.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WUser.h"

@implementation Y2WUser

- (instancetype)initWithBase:(UserBase *)base {
    if (self = [super init]) {
        self.ID        = base.ID;
        [self updateWithBase:base];
    }
    return self;
}

- (void)updateWithBase:(UserBase *)base {
    self.email     = base.email;
    self.name      = base.name;
    self.pinyin    = [base.pinyin componentsSeparatedByString:@","];
    self.phone     = base.phone;
    self.address   = base.address;
    self.jobTitle  = base.jobTitle;
    self.role      = base.role;
    self.status    = base.status;
    self.avatarUrl = base.avatarUrl;
    self.createdAt = base.createdAt.y2w_toString;
    self.updatedAt = base.updatedAt.y2w_toString;
}



- (void)getSession:(void (^)(NSError *, Y2WSession *))block {
    if (!block) return;
    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:self.ID type:@"p2p" success:^(Y2WSession *session) {
        block(nil, session);
    } failure:^(NSError *error) {
        block(error, nil);
    }];
}

- (void)getSessionAndAddContact:(void (^)(NSError *, Y2WSession *))block {
    Y2WContact *contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.ID];
    if (contact) {
        return [self getSession:block];
    }
    else {
        Y2WContact *contact = [[Y2WContact alloc] init];
        contact.userId = self.ID;
        contact.name = self.name;
        contact.avatarUrl = self.avatarUrl;
        contact.contacts = [Y2WUsers getInstance].getCurrentUser.contacts;
        [[Y2WUsers getInstance].getCurrentUser.contacts.remote addContact:contact success:^{
            [self getSessionAndAddContact:block];
        } failure:^(NSError *error) {
            if (block) {
                block(error, nil);
            }
        }];
    }
}




- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.ID) dict[@"id"] = self.ID;
    if (self.name) dict[@"name"] = self.name;
    if (self.email) dict[@"email"] = self.email;
    if (self.avatarUrl) dict[@"avatarUrl"] = self.avatarUrl;
    return dict;
}

@end
