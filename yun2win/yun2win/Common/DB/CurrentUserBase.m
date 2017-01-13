//
//  CurrentUserBase.m
//  API
//
//  Created by QS on 16/9/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "CurrentUserBase.h"

@implementation CurrentUserBase

+ (NSDictionary *)defaultPropertyValues {
    return @{@"loginDate":[NSDate date]};
}


+ (instancetype)createOrUpdateInDefaultRealmWithValue:(id)value {
    [value setValue:[value objectForKey:@"key"] forKey:@"appkey"];
    [value setValue:@([[value objectForKey:@"isDelete"] boolValue]) forKey:@"isDelete"];
    return [super createOrUpdateInDefaultRealmWithValue:value];
}

@end
