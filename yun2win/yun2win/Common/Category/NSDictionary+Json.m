//
//  NSDictionary+Json.m
//  API
//
//  Created by QS on 16/3/17.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (NSString *)toJsonString {
    return [self toJsonStringWithOptions:0 error:nil];
}

- (NSString *)toJsonStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end



@implementation NSString (Json)

- (id)parseJsonString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

@end
