//
//  Y2WLocationManger.h
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSErrorDomain const Y2WLocationMangerErrorDomain;


@interface Y2WLocationManger : NSObject

- (void)getCurrentLocation:(void(^)(NSError *error, CLLocation *location))block;

- (void)getCurrentLocationInfo:(void (^)(NSError *error, NSDictionary *info))block;

@end
