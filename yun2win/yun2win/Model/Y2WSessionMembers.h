//
//  Y2WSessionMembers.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WSessionMember.h"
#import "Y2WSessionMembersDelegate.h"
@class Y2WSession;
@class Y2WSessionMembersRemote;

@interface Y2WSessionMembers : NSObject

@property (nonatomic, weak) Y2WSession *session;

@property (nonatomic, strong) Y2WSessionMembersRemote *remote;




- (instancetype)initWithSession:(Y2WSession *)session;

- (void)addDelegate:(id<Y2WSessionMembersDelegate>)delegate;

- (void)removeDelegate:(id<Y2WSessionMembersDelegate>)delegate;


- (Y2WSessionMember *)getMemberWithUserId:(NSString *)userId;

- (NSArray *)getMembers;
- (NSArray *)getAllMembers;

@end







@interface Y2WSessionMembersRemote : NSObject

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members;

- (void)sync:(dispatch_block_t)block;


/**
 *  添加一组成员到Session
 *
 *  @param members 添加的成员数组
 *  @param success 添加成功的回调
 *  @param failure 添加失败的回调
 */
- (void)addSessionMembers:(NSArray<Y2WSessionMember *> *)members
                  success:(void (^)(void))success
                  failure:(void(^)(NSError *error))failure;


/**
 *  使用邮件邀请成员到Session
 *
 *  @param email   邮箱
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
- (void)inviteSessionMemberWithEmail:(NSString *)email
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure;


/**
 *  删除一个Session成员
 *
 *  @param member  要删除的成员对象
 *  @param success 删除成功的回调
 *  @param failure 删除失败的回调
 */
- (void)deleteSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void(^)(NSError *error))failure;


/**
 *  更新一个Session成员
 *
 *  @param member  要更新的成员对象
 *  @param success 更新成功的回调
 *  @param failure 更新失败的回调
 */
- (void)updateSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void(^)(NSError *error))failure;

@end
