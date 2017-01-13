//
//  Y2WMessages.h
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Y2WMessagesDelegate.h"
#import "Y2WMessagesPage.h"
#import "Y2WBaseMessage.h"
#import "Y2WTextMessage.h"
#import "Y2WImageMessage.h"
#import "Y2WVideoMessage.h"
#import "Y2WFileMessage.h"
#import "Y2WLocationMessage.h"
#import "LocationPoint.h"
#import "Y2WAudioMessage.h"
#import "Y2WSyncManager.h"
#import "Y2WAVMessage.h"

@class Y2WSession,Y2WMessagesRemote;
@interface Y2WMessages : NSObject

/**
 *  消息管理对象从属于某一会话，此处保存对会话的引用
 */
@property (nonatomic, weak) Y2WSession *session;

/**
 *  远程方法封装对象
 */
@property (nonatomic, retain) Y2WMessagesRemote *remote;

/**
 *  同步时间戳，同步时使用此时间戳获取之后的数据
 */
@property (nonatomic, copy) NSString *updateAt;


/**
 *  初始化一个消息管理对象
 *
 *  @param session 需要管理消息的session
 *
 *  @return 消息管理对象实例
 */
- (instancetype)initWithSession:(Y2WSession *)session;



/**
 *  添加委托对象
 *
 *  @param delegate 委托对象
 */
- (void)addDelegate:(id<Y2WMessagesDelegate>)delegate;



/**
 *  移除委托对象
 *
 *  @param delegate 委托对象
 */
- (void)removeDelegate:(id<Y2WMessagesDelegate>)delegate;



/**
 *  加载首次消息
 */
- (void)loadMessageFromDelegate:(id<Y2WMessagesDelegate>)delegate;



/**
 *  发送消息
 *
 *  @param message 有发送的消息对象
 */
- (void)sendMessage:(Y2WBaseMessage *)message;






- (Y2WAVMessage *)avMessageWithContent:(NSDictionary *)content;

- (Y2WTextMessage *)messageWithText:(NSString *)text;

- (Y2WImageMessage *)messageWithImage:(UIImage *)image;

- (Y2WVideoMessage *)messageWithVideoPath:(NSString *)videoPath;

- (Y2WLocationMessage *)messageWithLocationPoint:(LocationPoint *)locationPoint;

- (Y2WAudioMessage *)messageWithAudioPath:(NSString *)audioPath timer:(NSInteger)audioTimer;

@end






@interface Y2WMessagesRemote : NSObject

@property (nonatomic, retain) Y2WSyncManager *syncManager; // 同步管理器

/**
 *  消息远程方法管理对象
 *
 *  @param messages 创建该对象的消息管理对象
 *
 *  @return 远程管理对象实例
 */
- (instancetype)initWithMessages:(Y2WMessages *)messages;



/**
 *  从服务器同步消息
 */
- (void)sync;



/**
 *  保存一条消息到服务器
 *
 *  @param message 需要保存的消息
 *  @param success 保存成功后更新的消息
 *  @param failure 保存失败的错误回调
 */
- (void)storeMessages:(Y2WBaseMessage *)message
              success:(void (^)(Y2WBaseMessage *message))success
              failure:(void (^)(NSError *error))failure;


- (void)updataMessage:(Y2WBaseMessage *)message
              session:(Y2WSession *)session
              success:(void (^)(Y2WBaseMessage *message))success
              failure:(void (^)(NSError *error))failure;


- (void)uploadFile:(NSArray *)fileAppends
               progress:(ProgressBlock)progress
                success:(void(^)(NSArray *fileArray))success
                failure:(void(^)(NSError *error))failure;

@end
