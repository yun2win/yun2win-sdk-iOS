//
//  UserBase.m
//  API
//
//  Created by QS on 16/9/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserBase.h"

@implementation UserBase

+ (NSString *)primaryKey {
    return @"ID";
}

+ (instancetype)createOrUpdateInDefaultRealmWithValue:(id)value {
    [value setValue:[value objectForKey:@"id"] forKey:@"ID"];
    [value setValue:[[value objectForKey:@"email"] lowercaseString] forKey:@"email"];
    [value setValue:[[value objectForKey:@"pinyin"]  componentsJoinedByString:@","] forKey:@"pinyin"];
    [value setValue:@([[value objectForKey:@"isDelete"] boolValue]) forKey:@"isDelete"];
    [value setValue:[[value objectForKey:@"createdAt"] y2w_toDate] forKey:@"createdAt"];
    [value setValue:[[value objectForKey:@"updatedAt"] y2w_toDate] forKey:@"updatedAt"];
    return [super createOrUpdateInDefaultRealmWithValue:value];
}

@end
