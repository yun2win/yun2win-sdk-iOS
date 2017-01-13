//
//  IMSession.h
//  API
//
//  Created by ShingHo on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_IM_SDK/Y2W_IM_SDK.h>
@class Y2WSession;

@interface Y2WIMSessionMember : NSObject<Y2WIMSessionMember>

- (instancetype)initWithSessionMember:(Y2WSessionMember *)member;

@end

@interface IMSession : NSObject<Y2WIMSession>

// 发送消息时使用
- (instancetype)initWithSession:(Y2WSession *)session;

// 更新会话时使用
- (instancetype)initWithSession:(Y2WSession *)session needMembers:(BOOL)needMembers beginTime:(NSTimeInterval)time force:(BOOL)force;



// 创建WebApp会话使用
- (instancetype)initWithY2wIMAppUID:(NSString *)uid needMembers:(BOOL)needMembers;

@end
