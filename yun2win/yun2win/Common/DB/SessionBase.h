//
//  SessionBase.h
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface SessionBase : RLMObject

@property NSString *ID;

@property NSString *targetId;

@property NSString *name;

@property NSString *type;

@property NSString *secureType;

@property NSString *avatarUrl;

@property NSString *descriptions;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property BOOL nameChanged;

@property NSString *extend;

@end

RLM_ARRAY_TYPE(SessionBase)
