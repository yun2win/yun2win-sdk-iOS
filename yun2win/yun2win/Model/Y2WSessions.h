//
//  Y2WSessions.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSession.h"

@class Y2WCurrentUser;
@class Y2WSessionsRemote;

@interface Y2WSessions : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;

@property (nonatomic, retain) Y2WSessionsRemote *remote;


- (void)addOrUpdateWithBase:(SessionBase *)base;

/**
 *  初始化一个Session管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser;


/**
 *  从本地获取一个Session
 *
 *  @param sessionId ID
 *
 *  @return Session对象
 */
- (Y2WSession *)getSessionById:(NSString *)sessionId;


/**
 *  从本地获取一个Session
 *
 *  @param targetId 目标ID
 *  @param type     会话类型
 *
 *  @return Session对象
 */
- (Y2WSession *)getSessionByTargetId:(NSString *)targetId type:(NSString *)type;


/**
 *  根据条件获取一个Session对象
 *
 *  @param targetId 会话目标ID
 *  @param type     Session类型
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                       success:(void(^)(Y2WSession *session))success
                       failure:(void(^)(NSError *error))failure;



@end







@interface Y2WSessionsRemote : NSObject

@property (nonatomic, weak) Y2WSessions *sessions;

/**
 *  初始化一个Session管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithSessions:(Y2WSessions *)sessions;

/**
 *  根据条件获取一个Session对象
 *
 *  @param targetId 会话目标ID
 *  @param type     Session类型
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                       success:(void (^)(Y2WSession *session))success
                       failure:(void (^)(NSError *error))failure;

- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                        extend:(NSString *)extend
                       success:(void (^)(Y2WSession *))success
                       failure:(void (^)(NSError *))failure;

/**
 *  更新一个Session对象
 *
 *  @param session 要更新的对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)updateSession:(Y2WSession *)session
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

/**
 *  创建一个session
 *
 *  @param name       自定义名字
 *  @param type       类型（三种可选类型：@"p2p", @"single", @"group"）
 *  @param secureType 安全类型（两种类型：@"public", @"private"）
 *  @param avatarUrl  头像地址（可以是绝对地址也可以是相对地址，便于服务器维护）
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)addWithName:(NSString *)name
               type:(NSString *)type
         secureType:(NSString *)secureType
          avatarUrl:(NSString *)avatarUrl
            success:(void(^)(Y2WSession *session))success
            failure:(void(^)(NSError *error))failure;

/**
 *  创建一个session
 *
 *  @param name       自定义名字
 *  @param type       类型（三种可选类型：@"p2p", @"single", @"group"）
 *  @param secureType 安全类型（两种类型：@"public", @"private"）
 *  @param avatarUrl  头像地址（可以是绝对地址也可以是相对地址，便于服务器维护）
 *  @param extend     扩展属性
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)addWithName:(NSString *)name
               type:(NSString *)type
         secureType:(NSString *)secureType
          avatarUrl:(NSString *)avatarUrl
               role:(NSString *)role
             extend:(NSDictionary *)extend
            success:(void(^)(Y2WSession *session))success
            failure:(void(^)(NSError *error))failure;
@end
