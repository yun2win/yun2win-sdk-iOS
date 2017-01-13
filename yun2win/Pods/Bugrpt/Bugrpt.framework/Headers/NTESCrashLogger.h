//
//  BugrptLog.h
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

// Log level for Bugrpt Logger
typedef NS_ENUM(NSUInteger, BGRLogLevel) {
    BGRLogLevelSilent    = 0,      // 00000
    BGRLogLevelError     = 1 << 0, // 00001
    BGRLogLevelWarning   = 1 << 1, // 00010
    BGRLogLevelInfo      = 1 << 2, // 00100
    BGRLogLevelDebug     = 1 << 3, // 01000
    BGRLogLevelVerbose   = 1 << 4, // 10000
};

#pragma mark - Interface
@interface NTESCrashLogger : NSObject

/**
 *    @brief  初始化日志模块。如果不调用的话，level默认BGRLogLevelVerbose，printConsole默认NO
 *    @param level 设置默认日志控制级别,该级别以上的log才会打印(上报)
 *    @param printConsole 是否打印到控制台
 */
+ (void)initLogger:(BGRLogLevel)level consolePrint:(BOOL)printConsole;

/**
 *    @brief  打印(上报)日志，日志level为BGRLogLevelInfo
 *    @param format 格式化语句
 *
 *    @说明：log 总字节数限制 29K 或 总条数 200 条，超出的话会删除旧的
 *
 */
+ (void)log:(NSString *)format, ...;

/**
 *    @brief  打印(上报)指定级别日志
 *    @param level 设置日志级别，显示的日志级别
 *    @param format 格式化语句
 *
 *    @说明：log 总字节数限制 29K 或 总条数 200 条，超出的话会删除旧的
 *
 */
+ (void)level:(BGRLogLevel)level log:(NSString *)format, ...;

@end
