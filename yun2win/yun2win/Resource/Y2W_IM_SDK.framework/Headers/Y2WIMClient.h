//
//  Y2WIMClient.h
//  Y2W_IM_SDK
//
//  Created by QS on 16/9/7.
//  Copyright © 2016年 理约云. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WIMClient,Y2WIMClientConfig;


/**
 *  网络连接状态码
 */
typedef NS_ENUM(NSInteger, Y2WIMConnectionStatus) {
    Y2WIMConnectionStatusConnecting          = 0,  // 正在连接
    Y2WIMConnectionStatusConnected           = 1,  // 已连接
    Y2WIMConnectionStatusReconnecting        = 2,  // 重连中
    Y2WIMConnectionStatusNetworkDisconnected = 3,  // 网络断开
    Y2WIMConnectionStatusDisconnected        = 100 // 连接断开
};

/**
 *  消息推送返回码
 */
typedef NS_ENUM(NSInteger, Y2WIMConnectionReturnCode) {
    Y2WIMConnectionReturnCodeIdentifierRejected          = 2,  // clientId不合法
    Y2WIMConnectionReturnCodeUnacceptableProtocolVersion = 3,  // 协议错误
    Y2WIMConnectionReturnCodeUidIsInvalid                = 4,  // 用户ID无效
    Y2WIMConnectionReturnCodeTokenIsInvalid              = 5,  // imToken无效
    Y2WIMConnectionReturnCodeTokenHasExpired             = 6,  // imToken过期
    Y2WIMConnectionReturnCodeAuthenticationServerError   = 7,  // 鉴权服务器出错
    Y2WIMConnectionReturnCodeKicked                      = 10, // 被踢出，同类型设备重复登录时，之前设备收到提出信息
    Y2WIMConnectionReturnCodeAcceptConnect               = 11, // 允许连接
    Y2WIMConnectionReturnCodeServerUnavailable           = 99, // 服务器不可达
    Y2WIMConnectionReturnCodeServerInternalError         = 100,// 服务器内部错误
    Y2WIMConnectionReturnCodeRequestGateError            = 101 // 路由请求错误
};

/**
 *  发送消息的回执
 */
typedef NS_ENUM(NSInteger, Y2WIMSendReturnCode) {
    Y2WIMSendReturnCodeSuccess                      = 20, // 推送成功
    Y2WIMSendReturnCodeTimeout                      = 21, // 推送超时
    Y2WIMSendReturnCodeCmdIsInvalid                 = 22, // 推送命令无效
    Y2WIMSendReturnCodeSessionIsInvalid             = 23, // 会话无效
    Y2WIMSendReturnCodeSessionIdIsInvalid           = 24, // 会话ID无效
    Y2WIMSendReturnCodeSessionMTSIsInvalid          = 25, // 会话成员时间戳无效
    Y2WIMSendReturnCodeSessionOnServerIsNotExist    = 26, // 推送服务器不存在此会话
    Y2WIMSendReturnCodeSessionMTSOnClientHasExpired = 27, // 客户端会话成员时间戳过期
    Y2WIMSendReturnCodeSessionMTSOnServerHasExpired = 28, // 推送服务器会员时间戳过期
    Y2WIMSendReturnCodeSessionMembersIsInvalid      = 29, // 推送服务器会话成员无效
    Y2WIMSendReturnCodeInvalidFormatOfJSONContent   = 30, // 推送内容是无效的JSON格式
    Y2WIMSendReturnCodeSessionMembersIsNull         = 31  // 会话成员不存在
};








@protocol Y2WIMSessionMember <NSObject>

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) BOOL isDelete;

@end




@protocol Y2WIMSession <NSObject>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, retain) NSArray<id<Y2WIMSessionMember>> *members;

@property (nonatomic, assign) NSTimeInterval mts;

@property (nonatomic, assign) BOOL force;

@end







@protocol Y2WIMClientDelegate <NSObject>
// 网络状态变化
- (void)im_client:(Y2WIMClient *)client
didChangeOnlineStatus:(BOOL)isOnline;
// 连接状态变化
- (void)im_client:(Y2WIMClient *)client
  didChangeStatus:(Y2WIMConnectionStatus)status
       returnCode:(Y2WIMConnectionReturnCode)code;
// 收消息
- (void)im_client:(Y2WIMClient *)client
   didReceiveData:(NSDictionary *)data;
// 更新会话
- (void)im_client:(Y2WIMClient *)client
didSendUpdateMessage:(NSDictionary *)message
        toSession:(id<Y2WIMSession>)session
       returnCode:(Y2WIMSendReturnCode)code;
// 发消息回调
- (void)im_client:(Y2WIMClient *)client
   didSendMessage:(NSDictionary *)message
        toSession:(id<Y2WIMSession>)session
       returnCode:(Y2WIMSendReturnCode)code
              mts:(NSTimeInterval)mts;
@end






@interface Y2WIMClient : NSObject

@property (nonatomic, retain) id<Y2WIMClientDelegate>delegate;


- (instancetype)initWithDelegate:(id<Y2WIMClientDelegate>)delegate;
- (void)connectWithConfig:(Y2WIMClientConfig *)config;
- (void)reconnectWithToken:(NSString *)token;
- (void)disconnect;
- (void)closePush;

- (void)sendMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session;
- (void)sendUpdateMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session;

@end
