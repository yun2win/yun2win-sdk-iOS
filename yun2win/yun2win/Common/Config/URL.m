//
//  URL.m
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "URL.h"
#import "Y2WServiceConfig.h"

@implementation URL

+ (NSString *)getImToken
{
    return @"http://console.yun2win.com/oauth/token";
}

+ (NSString *)domain
{
    return Y2WServiceConfig.domain;
}

+ (NSString *)baseURL
{
    return Y2WServiceConfig.baseUrl;
}

+ (NSString *)userUrl {
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"/users/"];
}

+(NSString *)registerUser
{
    return [self.userUrl stringByAppendingString:@"register"];
}

+(NSString *)login
{
    return [self.userUrl stringByAppendingString:@"login"];
}

+(NSString *)setPassword {
    return [self.userUrl stringByAppendingFormat:@"setPassword"];
}

+(NSString *)aboutUser:(NSString *)userId
{
    return [self.userUrl stringByAppendingFormat:@"%@",userId];
}

+ (NSString *)acquireContacts
{
    return [self.userUrl stringByAppendingFormat:@"%@/contacts",[Y2WUsers getInstance].getCurrentUser.ID];
}

+ (NSString *)aboutContact:(NSString *)contactId
{
    return [self.userUrl stringByAppendingFormat:@"%@/contacts/%@",[Y2WUsers getInstance].getCurrentUser.ID,contactId];
}

+ (NSString *)contactsWithUID:(NSString *)uid {
    return [self.userUrl stringByAppendingFormat:@"%@/contacts",uid];
}

+ (NSString *)userConversationsWithUID:(NSString *)uid
{
    return [self.userUrl stringByAppendingFormat:@"%@/userConversations",uid];
}

+ (NSString *)singleUserConversation:(NSString *)userConversationId
{
    return [self.userUrl stringByAppendingFormat:@"%@/userConversations/%@",[Y2WUsers getInstance].getCurrentUser.ID,userConversationId];
}

+ (NSString *)userSessions
{
    return [self.userUrl stringByAppendingFormat:@"%@/userSessions",[Y2WUsers getInstance].getCurrentUser.ID];
}

+ (NSString *)aboutUserSessions:(NSString *)userSessions
{
    return [self.userUrl stringByAppendingFormat:@"%@/userSessions/%@",[Y2WUsers getInstance].getCurrentUser.ID,userSessions];
}

+ (NSString *)sessions
{
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"/sessions"];
}

+ (NSString *)p2pSessionWithUserA:(NSString *)userA andUserB:(NSString *)userB extend:(NSString *)extend
{
    if (extend) {
        extend = [@"?extend=" stringByAppendingString:extend];
    }
    else {
        extend = @"";
    }
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/p2p/%@/%@%@",userA,userB,extend];
}

+ (NSString *)singleSession
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/single/%@",[Y2WUsers getInstance].getCurrentUser.ID];
}

+ (NSString *)aboutSession:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@",sessionId];
}

+ (NSString *)sessionMembersWithSessionId:(NSString *)sessionId {
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/members",sessionId];
}

+ (NSString *)sessionMembersInviteWithSessionId:(NSString *)sessionId {
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/members/invite",sessionId];
}

+ (NSString *)singleSessionMember:(NSString *)memberId Session:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/members/%@",sessionId,memberId];
}

+ (NSString *)acquireMessages:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/messages",sessionId];
}

+ (NSString *)acquireHistoryMessage:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/messages/history",sessionId];
}

+(NSString *)aboutMessage:(NSString *)messageId Session:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/sessions/%@/messages/%@",sessionId,messageId];
}

+ (NSString *)attachments
{
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"/attachments"];
}

+ (NSString *)attachments:(NSString *)attachmentId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/attachments/%@",attachmentId];
}

+ (NSString *)attachmentsOfContent:(NSString *)attachmentId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/attachments/%@/content",attachmentId];
}

+(NSString *)attachmentsOfContentWithNoHeader:(NSString *)attachmentId
{
    return [NSString stringWithFormat:@"/attachments/%@/content",attachmentId];
}

+ (NSString *)getUsers {
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/users"];
}

+ (NSString *)emojis
{
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"/emojis"];
}

+ (NSString *)emojis:(NSString *)emojiId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"/emojis/%@",emojiId];
}

//全局搜索的
+ (NSString *)globalSearchUrlStr {
    
    return @"http://search.yun2win.com/getSearchCategory";
}

@end
