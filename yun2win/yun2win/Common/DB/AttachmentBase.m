//
//  AttachmentBase.m
//  yun2win
//
//  Created by QS on 16/10/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "AttachmentBase.h"

@implementation AttachmentBase

+ (NSString *)primaryKey {
    return @"ID";
}


+ (instancetype)createOrUpdateInDefaultRealmWithValue:(id)value {
    NSMutableDictionary *dict = [value mutableCopy];
    dict[@"ID"] = value[@"id"];
    dict[@"name"] = value[@"fileName"];
    dict[@"createdAt"] = [value[@"createdAt"] y2w_toDate];
    dict[@"updatedAt"] = [value[@"updatedAt"] y2w_toDate];
    return [super createOrUpdateInDefaultRealmWithValue:dict];
}

@end
