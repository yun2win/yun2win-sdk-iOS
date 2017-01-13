//
//  Y2WIMClientConfig.h
//  Y2W_IM_SDK
//
//  Created by QS on 16/9/7.
//  Copyright © 2016年 理约云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WIMClientConfig : NSObject

- (instancetype)initWithAppkey:(NSString *)appkey uid:(NSString *)uid token:(NSString *)token;

+ (void)setDeviceToken:(NSData *)deviceToken;

@end
