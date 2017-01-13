//
//  Y2WLog.m
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WLog.h"

@implementation Y2WLog

+ (void)log:(BGRLogLevel)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... {
    
    va_list args;
    
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        message = [NSString stringWithFormat:@"%s[第%@行]: %@",function,@(line),message];
        [NTESCrashLogger level:level log:message];
        va_end(args);
    }
}

@end
