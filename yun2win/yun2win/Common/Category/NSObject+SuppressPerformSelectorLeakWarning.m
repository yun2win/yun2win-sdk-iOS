//
//  NSObject+SuppressPerformSelectorLeakWarning.m
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSObject+SuppressPerformSelectorLeakWarning.h"

@implementation NSObject (SuppressPerformSelectorLeakWarning)

- (id)y2w_performSelector:(SEL)aSelector {
    _Pragma("clang diagnostic push")
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
    if ([self respondsToSelector:aSelector]) {
        [self performSelector:aSelector];
    }
    return nil;
    _Pragma("clang diagnostic pop")
}

@end
