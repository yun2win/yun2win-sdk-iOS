//
//  MulticastDelegate.m
//  API
//
//  Created by QS on 16/3/28.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "MulticastDelegate.h"

@interface MulticastDelegate ()

@property (nonatomic, retain) NSPointerArray *delegates;

@end


@implementation MulticastDelegate

- (void)addDelegate:(id)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index == NSNotFound) {
        [self.delegates addPointer:(__bridge void * _Nullable)(delegate)];
    }
}

- (void)removeDelegate:(id)delegate {
    
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound) [self.delegates removePointerAtIndex:index];
    [self.delegates compact];
}

- (void)removeAllDelegates {
    [self.delegates compact];
    while (self.delegates.count) {
        [self.delegates removePointerAtIndex:0];
    }
}

- (NSUInteger)indexOfDelegate:(id)delegate {
    
    for (NSUInteger i = 0; i < _delegates.count; i += 1) {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}






- (BOOL)respondsToSelector:(SEL)selector {
    
    if ([super respondsToSelector:selector]) return YES;
    
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:selector]) return YES;
    }
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (signature) return signature;
    
    [self.delegates compact];
    if (!self.count) return [self methodSignatureForSelector:@selector(description)];
    
    for (id delegate in self.delegates) {
        
        signature = [delegate methodSignatureForSelector:selector];
        if (signature) return signature;
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    SEL selector = [invocation selector];
    NSArray *copiedDelegates = [self.delegates copy];
    
    for (id delegate in copiedDelegates) {
        if (delegate && [delegate respondsToSelector:selector]) {
            [invocation invokeWithTarget:delegate];
        }
    }
}







#pragma mark - ———— getter ———— -

- (NSPointerArray *)delegates {
    
    if (!_delegates) {
        _delegates = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _delegates;
}

- (NSUInteger)count {
    
    NSPointerArray *delegates = [self.delegates copy];
    [delegates compact];
    return delegates.count;
}

@end
