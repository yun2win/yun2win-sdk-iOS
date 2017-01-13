//
//  Y2WSession.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WMessages.h"
#import "Y2WSessionMembers.h"
#import "SessionBase.h"

@class Y2WCurrentUser,Y2WSessions,Y2WUserConversation,SessionBase;
@interface Y2WSession : NSObject

@property (nonatomic, weak) Y2WSessions *sessions;

@property (nonatomic, retain) Y2WMessages *messages;

@property (nonatomic, retain) Y2WSessionMembers *members;


@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *secureType;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *descriptions;

@property (nonatomic, copy) NSDictionary *extend;

@property (nonatomic, copy) NSString *createMTS;

@property (nonatomic, copy) NSString *updateMTS;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *updatedAt;

@property (nonatomic, assign) BOOL nameChanged;

@property (nonatomic, copy) NSString *targetId;


@property (nonatomic, assign) NSInteger tryTime;


@property (nonatomic, readonly) Y2WUserConversation *userConversation; // 获取此会话的用户会话对象



- (instancetype)initWithSessions:(Y2WSessions *)sessions base:(SessionBase *)base;

- (void)updateWithBase:(SessionBase *)base;

- (NSString *)getName;
- (NSString *)getAvatarUrl;

@end

