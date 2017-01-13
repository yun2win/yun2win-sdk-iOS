//
//  Y2WIMBridge.h
//  API
//
//  Created by QS on 16/9/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSession.h"
@class Y2WIMBridge;

FOUNDATION_EXPORT NSString * const Y2W_IM_APPT_YPE;         // WebApp消息类型
FOUNDATION_EXPORT NSTimeInterval const Y2W_IM_APPT_YPE_MTS; // WebApp类型消息的MTS


typedef NS_ENUM(NSInteger, Y2WSyncType) {
    Y2WSyncTypeUserConversation = 0,
    Y2WSyncTypeMessage          = 1,
    Y2WSyncTypeContact          = 2,
    Y2WSyncTypeUserSession      = 3,
    Y2WSyncTypeSessionMember    = 4
};




@protocol Y2WIMBridgeDelegate <NSObject>

@optional
- (void)bridge:(Y2WIMBridge *)bridge didChangeOnlineStatus:(BOOL)isOnline;

- (void)bridge:(Y2WIMBridge *)bridge didReceiveMessage:(NSDictionary *)message;

- (void)bridge:(Y2WIMBridge *)bridge didLogoutWithMessage:(NSString *)message;

@end



@interface Y2WIMBridge : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;


- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;

- (void)addDelegate:(id<Y2WIMBridgeDelegate>)delegate;

- (void)removeDelegate:(id<Y2WIMBridgeDelegate>)delegate;

- (void)logoutWithMessage:(NSString *)message;


- (void)sendMessage:(NSDictionary *)message toSession:(IMSession *)session;

- (void)sendMessages:(NSArray<NSDictionary *> *)messages toSession:(IMSession *)session;

- (void)sendMessages:(NSArray<NSDictionary *> *)messages pushMessage:(NSDictionary *)pushMessage toSession:(IMSession *)session;

- (void)sendMessages:(NSArray<NSDictionary *> *)messages pushMessage:(NSDictionary *)pushMessage callMessage:(NSDictionary *)callMessage toSession:(IMSession *)session;

- (void)sendOtherDeviceMessages:(NSArray<NSDictionary *> *)messages;

@end
