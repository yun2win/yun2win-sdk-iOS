//
//  QSProtocol.h
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSProtocol : NSObject

- (instancetype)initWithProtocol:(Protocol *)protocol;
- (NSString *)name;
- (NSArray *)methodNames;

@end
