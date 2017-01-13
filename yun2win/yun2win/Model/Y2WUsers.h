//
//  Y2WUsers.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
#import "Y2WCurrentUser.h"
@class Y2WUsersRemote;

@interface Y2WUsers : NSObject

@property (nonatomic, retain) Y2WCurrentUser *currentUser;

@property (nonatomic, retain, readonly) Y2WUsersRemote *remote;

+ (instancetype)getInstance;

- (Y2WCurrentUser *)getCurrentUser;



/**
 *  根据用户ID获取一个用户对象，没有则返回nil
 *
 *  @param userId 用户ID
 *
 *  @return 获取的用户对象
 */
- (Y2WUser *)getUserById:(NSString *)userId;

- (void)getUserById:(NSString *)userId success:(void (^)(Y2WUser *user))success failure:(void (^)(NSError *error))failure;




- (Y2WUser *)getUserWithContact:(Y2WContact *)contact;
- (Y2WUser *)getUserWithSessionMember:(Y2WSessionMember *)member;

@end







@interface Y2WUsersRemote : NSObject

/**
 *  初始化用户远程管理对象
 *
 *  @param users 引用此对象的远程管理对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithUsers:(Y2WUsers *)users;



/**
 *  注册
 *
 *  @param account  注册的帐号
 *  @param password 注册的密码
 *  @param name     注册的名字
 *  @param success  注册成功的回调
 *  @param failure  注册失败的回调
 */
- (void)registerWithAccount:(NSString *)account
                   password:(NSString *)password
                       name:(NSString *)name
                    success:(void(^)(void))success
                    failure:(void(^)(NSError *error))failure;



/**
 *  登录
 *
 *  @param account  用户账号
 *  @param password 用户密码
 *  @param success  登录成功回调
 *  @param failure  登录失败回调
 */
- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void(^)(Y2WCurrentUser *currentUser))success
                 failure:(void(^)(NSError *error))failure;



/**
 *  搜索用户
 *
 *  @param key     关键字（可以是姓名或是邮箱）
 *  @param success 搜索成功的回调
 *  @param failure 搜索失败的回调
 */
- (void)searchUserWithKey:(NSString *)key
                  success:(void (^)(NSArray *users))success
                  failure:(void (^)(NSError *error))failure;



/**
 *  获取某用户
 *
 *  @param userId  用户ID
 *  @param success 保存成功的回调
 *  @param failure 保存失败的回调
 */
- (void)getUserById:(NSString *)userId
            success:(void(^)(Y2WUser * user))success
            failure:(void(^)(NSError *error))failure;

/**
 *  获取某用户
 *
 *  @param userId  用户ID
 *  @param success 保存成功的回调
 *  @param failure 保存失败的回调
 */
- (void)getUserByIds:(NSArray<NSString *> *)uids
             success:(void(^)(NSArray<Y2WUser *> *users))success
             failure:(void(^)(NSError *error))failure;

@end
