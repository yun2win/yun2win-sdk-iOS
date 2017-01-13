//
//  SessionMemberBase.h
//  API
//
//  Created by ShingHo on 16/8/28.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface SessionMemberBase : RLMObject

@property NSString *sessionId;

@property NSString *userId;

@property NSString *ID;

@property NSString *name;

@property NSString *pinyin;

@property NSString *role;

@property NSString *status;

@property NSString *avatarUrl;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property NSDate *lastReadTime;

@property int time;

@property BOOL isDelete;

@property NSString *extend;
@end

RLM_ARRAY_TYPE(SessionMemberBase)
