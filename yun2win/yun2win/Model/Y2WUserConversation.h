//
//  Y2WUserConversation.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
@class Y2WUserConversations;
@class UserConversationBase;

@interface Y2WUserConversation : NSObject

@property (nonatomic, weak) Y2WUserConversations *userConversations;


@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *targetId; // type为p2p时为对方UserId,type为group时为sessionId
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;     // "p2p", "single", "group","assistant"
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, assign) BOOL visiable;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) NSInteger unRead;
@property (nonatomic, copy) NSString *draft;



- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations base:(UserConversationBase *)base;

- (void)updateWithBase:(UserConversationBase *)base;



- (NSString *)getName;

- (NSString *)getAvatarUrl;

- (void)getSessionDidCompletion:(void(^)(Y2WSession *session, NSError *error))block;





/**
 *  移除未读数
 */
- (void)clearUnRead;



#pragma mark - ———— 构造方法 ———— -

- (NSDictionary *)toParameters;

@end

