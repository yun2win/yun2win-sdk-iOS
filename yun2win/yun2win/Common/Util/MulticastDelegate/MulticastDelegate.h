//
//  MulticastDelegate.h
//  API
//
//  Created by QS on 16/3/28.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MulticastDelegate : NSObject

@property (nonatomic, readonly) NSUInteger count;

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

@end
