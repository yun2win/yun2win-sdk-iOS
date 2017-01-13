//
//  Y2WLog.h
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//


#define LOG_MACRO_TO_Y2WLOG(lvl, frmt, ...) [Y2WLog log:lvl file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__  format:frmt, ##__VA_ARGS__]
#define NSLog(frmt, ...) LOG_MACRO_TO_Y2WLOG(BGRLogLevelDebug, frmt, ##__VA_ARGS__)
#define Y2WErrorLog(frmt, ...) LOG_MACRO_TO_Y2WLOG(BGRLogLevelError, frmt, ##__VA_ARGS__)
#define Y2WInfoLog(frmt, ...) LOG_MACRO_TO_Y2WLOG(BGRLogLevelInfo, frmt, ##__VA_ARGS__)

#import <Foundation/Foundation.h>
#import <Bugrpt/NTESCrashLogger.h>

@interface Y2WLog : NSObject

+ (void)log:(BGRLogLevel)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

@end
