//
//  DataPickerModel.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataPickerModel.h"

@implementation DataPickerModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.multiple = [dict[@"mode"] isEqualToString:@"multiple"];
        self.avatar = [dict[@"avatar"] boolValue];
        self.folder = [dict[@"folder"] boolValue];
        self.selectFolder = [dict[@"selectFolder"] boolValue];
   
        NSMutableArray *dataSource = [NSMutableArray array];
        for (NSDictionary *itemDict in dict[@"dataSource"]) {
            DataPickerItem *item = [[DataPickerItem alloc] initWithDict:itemDict];
            [dataSource addObject:item];
        }
        self.dataSource = dataSource;
        
        NSMutableDictionary *items = [NSMutableDictionary dictionary];
        [self items:self.dataSource ToDict:items];
        
        
        self.selected = [NSMutableDictionary dictionary];
        if ([dict[@"selected"] isKindOfClass:[NSArray class]]) {
            for (NSString *uid in dict[@"selected"]) {
                DataPickerItem *item = items[uid];
                if (item) {
                    self.selected[uid] = item;
                }
            }
        }
    }
    return self;
}

- (void)items:(NSArray<DataPickerItem *> *)items ToDict:(NSMutableDictionary *)dict {
    for (DataPickerItem *item in items) {
        dict[item.ID] = item;
       
        if (item.children.count) {
            [self items:item.children ToDict:dict];
        }
    }
}

@end
