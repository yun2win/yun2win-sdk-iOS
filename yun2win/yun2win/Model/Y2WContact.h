//
//  Y2WContact.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
#import "Y2WSession.h"
#import "Y2WUserConversation.h"
@class ContactBase;
@class Y2WContacts;

@interface Y2WContact : NSObject

@property (nonatomic, weak) Y2WContacts *contacts;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray  *pinyin;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray  *titlePinyin;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *updatedAt;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, retain) NSDictionary *extend;

@property (nonatomic, retain, readonly) Y2WUser *user;



- (instancetype)initWithContacts:(Y2WContacts *)contacts base:(ContactBase *)base;

- (void)updateWithBase:(ContactBase *)base;



- (NSString *)getName;

- (NSString *)getAvatarUrl;

- (Y2WUserConversation *)getUserConversation;

- (void)getSessionDidCompletion:(void(^)(Y2WSession *session, NSError *error))block;

@end

