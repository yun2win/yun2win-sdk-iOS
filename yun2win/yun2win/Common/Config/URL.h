//
//  URL.h
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URL : NSObject

+ (NSString *)getImToken;

+ (NSString *)domain;

+ (NSString *)baseURL;

+ (NSString *)registerUser;

+ (NSString *)login;

+ (NSString *)setPassword;

+ (NSString *)aboutUser:(NSString *)userId;

+ (NSString *)acquireContacts;

+ (NSString *)aboutContact:(NSString *)contactId;

+ (NSString *)contactsWithUID:(NSString *)uid;

+ (NSString *)userConversationsWithUID:(NSString *)uid;

+ (NSString *)singleUserConversation:(NSString *)userConversationId;

+ (NSString *)userSessions;

+ (NSString *)aboutUserSessions:(NSString *)userSessions;

+ (NSString *)sessions;

+ (NSString *)p2pSessionWithUserA:(NSString *)userA andUserB:(NSString *)userB extend:(NSString *)extend;

+ (NSString *)singleSession;

+ (NSString *)aboutSession:(NSString *)sessionId;

+ (NSString *)sessionMembersWithSessionId:(NSString *)sessionId;

+ (NSString *)sessionMembersInviteWithSessionId:(NSString *)sessionId;

+ (NSString *)singleSessionMember:(NSString *)memberId Session:(NSString *)sessionId;

+ (NSString *)acquireMessages:(NSString *)sessionId;

//全局搜索的
+ (NSString *)globalSearchUrlStr;

/**
 *  历史会话消息
 *
 *  @param sessionId 会话ID
 *
 *  @return
 */
+ (NSString *)acquireHistoryMessage:(NSString *)sessionId;

/**
 *  会话消息
 *
 *  @param messageId 消息ID
 *  @param SessionId 会话ID
 *
 *  @return 
 */
+ (NSString *)aboutMessage:(NSString *)messageId Session:(NSString *)sessionId;

/**
 *  附件集
 *
 *  @return
 */
+ (NSString *)attachments;

/**
 *  附件
 *
 *  @param attachmentId 附件ID
 *
 *  @return
 */
+ (NSString *)attachments:(NSString *)attachmentId;

/**
 *  附件的字节流
 *
 *  @param attachmentId 附件ID
 *
 *  @return 
 */
+ (NSString *)attachmentsOfContent:(NSString *)attachmentId;

+ (NSString *)attachmentsOfContentWithNoHeader:(NSString *)attachmentId;

/**
 *  获取用户列表（配合filter_term进行筛选）
 *
 *  @return url字符串
 */
+ (NSString *)getUsers;

/**
 *  应用的表情集
 *
 *  @return
 */
+ (NSString *)emojis;

/**
 *  应用的某个表情
 *
 *  @param emojiId 表情Id
 *
 *  @return 
 */
+ (NSString *)emojis:(NSString *)emojiId;

@end


