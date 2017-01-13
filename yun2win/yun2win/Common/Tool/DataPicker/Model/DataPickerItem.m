//
//  DataPickerItem.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataPickerItem.h"
#include "DataPickerModel.h"

@implementation DataPickerItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
        self.avatarUrl = dict[@"avatarUrl"];
        self.folder = [dict[@"folder"] boolValue];
        
        NSMutableArray *children = [NSMutableArray array];
        for (NSDictionary *itemDict in dict[@"children"]) {
            DataPickerItem *item = [[DataPickerItem alloc] initWithDict:itemDict];
            [children addObject:item];
        }
        self.children = children;
    }
    return self;
}

- (BOOL)isEqual:(DataPickerItem *)object {
    if (![object isKindOfClass:[DataPickerItem class]]) {
        return NO;
    }
    return [object.ID isEqual:self.ID];
}

@end
