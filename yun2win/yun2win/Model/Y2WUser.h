//
//  Y2WUser.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "UserBase.h"
@class Y2WSession;

@interface Y2WUser : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray  *pinyin;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *jobTitle;

@property (nonatomic, copy) NSString *role;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *updatedAt;

@property (nonatomic, retain) NSDate *lastUpdate;

- (instancetype)initWithBase:(UserBase *)base;
- (void)updateWithBase:(UserBase *)base;


- (void)getSession:(void(^)(NSError *error, Y2WSession *session))block;

- (void)getSessionAndAddContact:(void(^)(NSError *error, Y2WSession *session))block;



- (NSDictionary *)toDict;

@end

