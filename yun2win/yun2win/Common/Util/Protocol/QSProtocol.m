//
//  QSProtocol.m
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "QSProtocol.h"
#import <objc/runtime.h>

@interface QSProtocol ()

@property (nonatomic, weak) Protocol *protocol;

@end

@implementation QSProtocol

- (instancetype)initWithProtocol:(Protocol *)protocol {
    if (self = [super init]) {
        self.protocol = protocol;
    }
    return self;
}

- (NSString *)name {
    return NSStringFromProtocol(self.protocol);
}


- (NSArray *)methodNames {
    unsigned int count;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList([self protocol], NO, YES, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++) {
        [array addObject:NSStringFromSelector(methods[i].name)];
    }
    free(methods);
    return array;
}

@end
