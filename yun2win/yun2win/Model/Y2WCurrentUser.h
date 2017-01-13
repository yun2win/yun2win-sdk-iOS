//
//  Y2WCurrentUser.h
//  API
//
//  Created by ShingHo on 16/3/3.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WUser.h"
#import "Y2WContacts.h"
#import "Y2WSessions.h"
#import "Y2WUserConversations.h"
#import "Y2WAttachments.h"
#import "Y2WIMBridge.h"
#import "CurrentUserBase.h"

FOUNDATION_EXPORT NSErrorDomain const Y2WCurrentUserErrorDomain;

@class Y2WCurrentUserRemote;

@interface Y2WCurrentUser : Y2WUser

@property (nonatomic, retain) Y2WContacts *contacts;

@property (nonatomic, retain) Y2WSessions *sessions;

@property (nonatomic, retain) Y2WUserConversations *userConversations;

@property (nonatomic, retain) Y2WAttachments *attachments;

@property (nonatomic, retain) Y2WCurrentUserRemote *remote;


@property (nonatomic, retain) Y2WIMBridge *bridge;

@property (nonatomic, retain) RLMRealm *realm;



@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *secret;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *imToken;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *authorization;



- (instancetype)initWithBase:(CurrentUserBase *)base;



- (NSDictionary *)toDict;

@end






@interface Y2WCurrentUserRemote : NSObject

/**
 *  初始化一个当前用户的远程管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser;



/**
 *  更改密码
 *
 *  @param password    密码
 *  @param oldPassword 旧密码
 *  @param block       回调
 */
- (void)setPassword:(NSString *)password fromOldPassword:(NSString *)oldPassword completion:(void (^)(NSError *error))block;



/**
 *  保存数据
 *
 *  @param block 请求结束的回调，失败会返回error对象
 */
- (void)store:(void(^)(NSError *error))block;



/**
 *  同步
 */
- (void)sync:(void (^)(NSError *error))block;



/**
 *  同步IMToken
 */
- (void)syncIMToken:(void (^)(NSError *error))block;


@end
