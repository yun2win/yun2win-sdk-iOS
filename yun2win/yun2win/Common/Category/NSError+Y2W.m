//
//  NSError+Y2W.m
//  API
//
//  Created by QS on 16/9/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSError+Y2W.h"
#import <WebKit/WebKit.h>

@implementation NSError (Y2W)

- (NSString *)message {

    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        return [self urlErrorDomainMessage];
    }
    
    if ([self.domain isEqualToString:WKErrorDomain]) {
        return self.description;
    }
    
    if ([self.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
        if ([self.userInfo[NSURLErrorFailingURLErrorKey] isY2WHost]) {
            return [self yun2winResponseErrorDomainMessage];
            
        }else {
            return self.userInfo[NSLocalizedDescriptionKey];
        }
    }
    
    if ([self.domain isEqualToString:Y2WCurrentUserErrorDomain] ||
        [self.domain isEqualToString:Y2WLocationMangerErrorDomain]) {
        return [self yun2winErrorDomainMessage];
    }
    
    return self.description;
}



- (NSString *)urlErrorDomainMessage {
    switch (self.code) {
            case NSURLErrorCancelled:
            return @"取消成功";
            
            case NSURLErrorCannotFindHost:
            case NSURLErrorNotConnectedToInternet:
            return @"找不到网络,请求失败";
            
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorTimedOut:
            return @"请求超时,请重试";
            
            case NSURLErrorCannotConnectToHost:
            return @"连接服务器失败,请重试";
    }
    return self.description;
}



- (NSString *)yun2winResponseErrorDomainMessage {
    NSString *jsonString = [[NSString alloc] initWithData:self.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    if (!jsonString) {
        return @"解析错误失败";
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    id message = dict[@"message"];
    if ([message isKindOfClass:[NSDictionary class]]) {
        message = message[@"error"];
    }
    if (![message isKindOfClass:[NSString class]]) {
        message = @"未知错误";
    }
    return message;
}

- (NSString *)yun2winErrorDomainMessage {
    NSString *message = self.userInfo[@"message"];
    if ([message isKindOfClass:[NSDictionary class]] ||
        [message isKindOfClass:[NSArray class]]) {
        message = [(NSDictionary *)message toJsonString];
    }
    if (![message isKindOfClass:[NSString class]]) {
        message = @"未知错误";
    }
    return message;
}

@end
