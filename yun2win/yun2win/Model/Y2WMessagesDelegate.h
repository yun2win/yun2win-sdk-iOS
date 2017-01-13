//
//  Y2WMessagesDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WMessages,Y2WBaseMessage,Y2WMessagesPage;
@protocol Y2WMessagesDelegate <NSObject>

@optional
/**
 *  同步完成
 *
 *  @param messages 消息管理对象
 *  @param error    错误返回,如果收取成功,error为nil
 */
- (void)messages:(Y2WMessages *)messages
didFistSyncWithError:(NSError *)error;



/**
 *  更新消息的回调
 *
 *  @param messages 消息管理对象
 *  @param message  更新的消息
 */
- (void)messages:(Y2WMessages *)messages
 onUpdateMessage:(Y2WBaseMessage *)message;



/**
 *  即将发送消息
 *
 *  @param messages 消息管理对象
 *  @param message  发送的消息
 */
- (void)messages:(Y2WMessages *)messages
 willSendMessage:(Y2WBaseMessage *)message;



/**
 *  发送消息完成回调
 *
 *  @param messages 消息管理对象
 *  @param message  当前发送的消息
 *  @param error    失败原因,如果发送成功则error为nil
 */
- (void)messages:(Y2WMessages *)messages
     sendMessage:(Y2WBaseMessage *)message
didCompleteWithError:(NSError *)error;


@end
