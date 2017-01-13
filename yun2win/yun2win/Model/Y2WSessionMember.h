//
//  Y2WSessionMember.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
@class Y2WSessionMembers;
@class SessionMemberBase;
@interface Y2WSessionMember : NSObject

@property (nonatomic, weak) Y2WSessionMembers *sessionMembers;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray *pinyin;

@property (nonatomic, copy) NSString *role; // ["master", "admin", "user"]

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *updatedAt;

@property (nonatomic, copy) NSString *lastReadTime;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, retain, readonly) Y2WUser *user;

@property (nonatomic, copy) NSDictionary *extend;

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members base:(SessionMemberBase *)base;
- (void)updateWithBase:(SessionMemberBase *)base;


- (NSString *)getAvatarUrl;




- (NSDictionary *)toDict;

@end
