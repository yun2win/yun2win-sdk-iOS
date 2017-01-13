//
//  NSObject+SuppressPerformSelectorLeakWarning.h
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SuppressPerformSelectorLeakWarning)

- (id)y2w_performSelector:(SEL)aSelector;

@end
