//
//  NTESCrashReporter.h
//
//  Created by Monkey on 15/3/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@protocol NTESCrashReporterDelegate <NSObject>

@optional

/**
 *  异常回调接口，这个接口尽量避免使用复杂的代码
 *
 *  @param exception 异常信息
 *
 *  @return 字串，限长 1024 字节，超出截断
 */
- (NSString *)attachmentForException:(NSException *)exception;

@end

@interface NTESCrashReporter : NSObject

/**
 *  单例
 *
 *  @return 返回NTESCrashReporter对象
 */
+ (NTESCrashReporter *)sharedInstance;

#pragma mark 参数设置

/**
 *  设置异常回调代理
 *
 *  @param delegate 代理对象
 */
- (void)setBugrptDelegate:(id<NTESCrashReporterDelegate>) delegate;

/**
 *  设置用户ID
 *
 *  @param userid 用户id
 */
- (void)setUserId:(NSString *)userid;

/**
 *  设置用户的一些标记信息
 *
 *  @param tag 标记信息
 */
- (void)setUserTag:(NSString *)tag;

/**
 *  设置渠道标识, 默认为空值
 *
 *  @param channel 渠道名称
 *
 *  @说明 如需修改设置, 请在初始化方法之前调用设置
 */
- (void)setChannel:(NSString *)channel;

/**
 *  是否开启sdk日志打印
 *
 *  @param enabled YES:开启;NO:不开启
 *
 *  @说明 默认为NO,只打印workflow
 */
- (void)enableLog:(BOOL)enabled;

/**
 *  设置自定义参数
 *
 *  @param key   key
 *  @param value value
 *
 *  @说明  自定义参数的设置: 最多可以有 20 对自定义的 key-value（超出部分遵循先进先出原则，删除最先添加的数据），key 限长 50 字节，value 限长 200 字节，过长截断
 *
 */
- (void)setUserParams:(NSString *)key value:(NSString *)value;

#pragma mark SDK初始化

/**
 *  iOS APP崩溃收集初始化接口
 *
 *  @param appId 云捕官网注册的App Id
 *
 *  @return 初始化是否成功
 */
- (BOOL)initWithAppId:(NSString *)appId;

/**
 *  初始化SDK接口并启动崩溃捕获上报功能, 如果你的App包含Application Extension或App Watch 1扩展，采用此方法初始化
 *
 *  @param appId      云捕官网注册的App Id
 *  @param identifier AppGroup标识, 开启App-Groups功能时, 定义的Identifier
 *
 *  @return 初始化是否成功
 */
- (BOOL)initWithAppId:(NSString *)appId applicationGroupIdentifier:(NSString *)identifier;

/**
 *  iOS APP崩溃收集初始化接口
 *
 *  @param appId        云捕官网注册的App Id
 *  @param customParams 产品需要传递的自定义参数, 不传默认为空
 *
 *  @return 初始化是否成功
 */
- (BOOL)iosCrashInitWithAppId:(NSString *)appId customParams:(NSString *)customParams;

#pragma mark 其他功能接口

/**
 *  主动上报用户自定义的异常，比如日志信息
 *
 *  @param type    类别
 *  @param content 内容
 */
- (void)uploadCustomizedException:(NSString* )type value:(NSString *)content;

/**
 *  上报用户自己捕获的异常，例如：@try ... @catch ... 到的NSException
 *
 *  @param exception 异常信息
 *  @说明 和 "- (void)reportException:(NSException *)exception"功能一样
 */
- (void)uploadCaughtException:(NSException *)exception;

/**
 *  上报用户自己获取的错误信息
 *
 *  @param error NSError错误信息
 *  @说明 和 "- (void)reportError:(NSError *)error"功能一样
 */
- (void)uploadCaughtError:(NSError *)error;

/**
 *  上报用户自己捕获的异常，例如：@try ... @catch ... 到的NSException
 *
 *  @param exception 异常信息
 */
- (void)reportException:(NSException *)exception __attribute__((deprecated("please use uploadCaughtException: instead")));;

/**
 *  上报用户自己获取的错误信息
 *
 *  @param error NSError错误信息
 */
- (void)reportError:(NSError *)error __attribute__((deprecated("please use uploadCaughtError: instead")));

/**
 *  开启卡顿接口
 *
 *  @param enable 为true表示开启，false关闭。默认是false
 *  @param count 限制卡顿捕捉次数，小于或等于0的值表示不限制，默认不限制
 *  @param monitorTimeout 卡顿间隔时间，单位为ms，默认3000ms
 *  @param monitorTimeoutCount 卡顿连续次数，默认1次
 */
- (void)setBlockMonitorStatus:(BOOL)enable;
- (void)setBlockMonitorStatus:(BOOL)enable limitCount:(int)count;
- (void)setBlockMonitorStatus:(BOOL)enable limitCount:(int)count timeout:(NSTimeInterval)monitorTimeout;
- (void)setBlockMonitorStatus:(BOOL)enable limitCount:(int)count timeout:(NSTimeInterval)monitorTimeout count:(NSInteger)monitorTimeoutCount;

/**
 *  关闭崩溃收集接口
 *  
 *  @说明 初始化SDK后，调用这个接口会关闭崩溃信息收集
 */
- (void)stop;

/**
 *  清理云捕缓存接口
 *
 *  @说明 调用这个接口会删除保存在本地的所有历史崩溃数据
 */
- (void)clearCaches;

#pragma mark 用于模拟异常测试

/**
 *  触发一个Object-C的异常
 */
- (void)triggerNSException;

/**
 *  触发一个错误信号
 */
- (void)triggerSignalError;

#pragma mark 内部调用

/**
 *  是否使用测试服务器
 *
 *  @param useTestAddr 默认是NO,都使用正式服务器,用户不需要设置这个
 *  @说明 内部调用函数,正式产品不需要调用
 */
- (void)setUseTestAddr:(BOOL)useTestAddr;

@end


