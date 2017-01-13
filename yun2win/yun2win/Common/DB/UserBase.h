//
//  UserBase.h
//  API
//
//  Created by QS on 16/9/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserBase : RLMObject

@property NSString *ID;

@property NSString *email;  // "email": "chengwenZhang@y2w.com",

@property NSString *name;

@property NSString *pinyin; // @[@"zhang",@"san"]

@property NSString *phone;

@property NSString *address;

@property NSString *avatarUrl;

@property NSString *jobTitle;

@property NSString *role;

@property NSString *status;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property BOOL isDelete;

@end


RLM_ARRAY_TYPE(UserBase)
