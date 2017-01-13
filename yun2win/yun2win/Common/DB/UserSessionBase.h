//
//  UserSessionBase.h
//  API
//
//  Created by ShingHo on 16/8/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserSessionBase : RLMObject

@property NSString *sessionId;

@property NSString *ID;

@property NSString *name;

@property NSString *avatarUrl;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property BOOL isDelete;

@end

RLM_ARRAY_TYPE(UserSessionBase)
