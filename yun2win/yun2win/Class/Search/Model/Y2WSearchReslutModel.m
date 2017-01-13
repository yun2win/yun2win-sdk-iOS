//
//  Y2WSearchReslutModel.m
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSearchReslutModel.h"

@implementation Y2WSearchReslutModel

- (instancetype)initWithUserConversation:(Y2WUserConversation *)userConversation searchText:(NSString *)text {
    if (self = [super init]) {
        self.name = [userConversation.getName setColor:[UIColor redColor] forText:text];
        self.text = [userConversation.text setColor:[UIColor redColor] forText:text];
        self.type = userConversation.type;
        self.targetId = userConversation.targetId;
        self.avatarUrl = userConversation.getAvatarUrl;
    }
    return self;
}


- (instancetype)initWithUserContact:(Y2WContact *)contact searchText:(NSString *)text {
    if (self = [super init]) {
        self.name = [contact.getName setColor:[UIColor redColor] forText:text];
        self.text = nil;
        self.type = @"p2p";
        self.targetId = contact.userId;
        self.avatarUrl = contact.getAvatarUrl;
    }
    return self;
}


- (instancetype)initWithUserMessageBase:(MessageBase *)base searchText:(NSString *)text {
    Y2WSession *session = [[Y2WUsers getInstance].getCurrentUser.sessions getSessionById:base.sessionId];
    if (!session) {
        return nil;
    }
    if (self = [super init]) {
        self.type = session.type;
        self.targetId = session.targetId;
        self.avatarUrl = session.getAvatarUrl;
        self.name = [session.getName setColor:[UIColor redColor] forText:text];
     
        NSString *content = base.text;
        if ([self.type isEqualToString:@"group"]) {
            Y2WUser *user = [[Y2WUsers getInstance] getUserById:base.sender];
            if (user) {
                content = [user.name stringByAppendingFormat:@": %@", content];
            }
        }
        self.text = [content setColor:[UIColor redColor] forText:text];
    }
    return self;
}

@end