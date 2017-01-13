//
//  NSArray+QSExtension.m
//  API
//
//  Created by QS on 16/4/5.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSArray+QSExtension.h"

@implementation NSArray (QSExtension)

- (NSArray *)qs_map:(id (^)(id, NSUInteger))block {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [result addObject:block(obj, idx)];
    }];
    return result;
}


- (NSArray *)qs_compact {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [result addObject:obj];
        }
    }];
    return result;
}

@end
