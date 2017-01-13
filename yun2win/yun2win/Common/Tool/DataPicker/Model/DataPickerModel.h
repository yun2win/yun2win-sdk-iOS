//
//  DataPickerModel.h
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPickerItem.h"


@interface DataPickerModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, retain) NSMutableDictionary *selected;

@property (nonatomic, retain) NSArray<DataPickerItem *> *dataSource;

@property (nonatomic, assign) BOOL multiple;

@property (nonatomic, assign) BOOL avatar;

@property (nonatomic, assign) BOOL folder;

@property (nonatomic, assign) BOOL selectFolder;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
