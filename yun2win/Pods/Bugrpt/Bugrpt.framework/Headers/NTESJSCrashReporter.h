//
//  NTESJSCrashReporter.h
//
//  Created by Monkey on 16/1/21.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NTESJSSupportProtocol <JSExport>

/**
 *  JavaScript 上报异常接口
 *
 *  @param exception JS捕获到的exception
 */
- (void)reportJSException:(id)exception;

@end

@interface NTESJSCrashReporter : NSObject<NTESJSSupportProtocol>

+ (NTESJSCrashReporter *)sharedInstance;

/**
 *  初始化JS异常捕获机制
 *
 *  @param webView 需要捕获的UIWebView实例
 *  @param inject  是否自动注入脚本文件,以便获取更加详细的异常信息
 */
- (void)initJSCrashReporterWithWebView:(UIWebView *)webView injectScript:(BOOL)inject;

@end

#endif