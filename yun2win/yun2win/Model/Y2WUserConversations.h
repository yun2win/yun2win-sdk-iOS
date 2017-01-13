//
//  Y2WUserConversations.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUserConversationsDelegate.h"
#import "Y2WUserConversation.h"
@class Y2WCurrentUser;
@class Y2WUserConversationsRemote;

@interface Y2WUserConversations : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;

@property (nonatomic, strong) Y2WUserConversationsRemote *remote;



- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;


- (void)addDelegate:(id<Y2WUserConversationsDelegate>)delegate;

- (void)removeDelegate:(id<Y2WUserConversationsDelegate>)delegate;



- (Y2WUserConversation *)getUserConversationById:(NSString *)userConversationId;

- (Y2WUserConversation *)getUserConversationWithTargetId:(NSString *)targetId
                                                    type:(NSString *)type;

- (NSArray *)getUserConversations;

@end




@interface Y2WUserConversationsRemote : NSObject

/**
 *  初始化一个用户会话远程管理对象
 *
 *  @param userConversations 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations;

- (void)sync:(dispatch_block_t)block;

/**
 *  删除用户会话
 *
 *  @param userConversation 需要删除的用户会话对象
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)deleteUserConversation:(Y2WUserConversation *)userConversation
                       success:(void(^)(void))success
                       failure:(void(^)(NSError *error))failure;



/**
 *  更新一个用户会话
 *
 *  @param userConversation 需要更新的用户会话
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)updateUserConversation:(Y2WUserConversation *)userConversation
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *))failure;
@end
