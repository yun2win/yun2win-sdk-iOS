//
//  DataPickerItem.h
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataPickerModel;

@interface DataPickerItem : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, assign) BOOL folder;

@property (nonatomic, copy) NSArray<DataPickerItem *> *children;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
