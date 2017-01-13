//
//  NSDate+Y2W.m
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

static NSString *Y2W_DateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";


#import "NSDate+Y2W.h"

@implementation NSDate (Y2W)

+ (NSDate *)dateWithMTS:(NSTimeInterval)mts {
    return [NSDate dateWithTimeIntervalSince1970:mts/1000];
}

- (NSString *)y2w_toString {
    return [self formattedDateWithFormat:Y2W_DateFormat timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
}

- (NSTimeInterval)y2w_toMTS {
    return [self timeIntervalSince1970] * 1000;
}

@end



@implementation NSString (Y2W)

- (NSDate *)y2w_toDate {
    return [NSDate dateWithString:self formatString:Y2W_DateFormat timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
}

- (NSTimeInterval)y2w_toMTS {
    return [[self y2w_toDate] y2w_toMTS];
}

@end
