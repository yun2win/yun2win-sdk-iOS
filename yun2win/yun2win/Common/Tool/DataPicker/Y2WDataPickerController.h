//
//  Y2WDataPickerController.h
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickerModel.h"

@interface Y2WDataPickerController : UINavigationController

@property (nonatomic, retain) DataPickerModel *model;

@property (nonatomic, assign) UIEdgeInsets contentInset;


- (instancetype)initWithModel:(DataPickerModel *)model handler:(void(^)(NSArray *ids))handler;

- (void)pushItem:(DataPickerItem *)item;

- (void)selectItem:(DataPickerItem *)item;

- (void)deselectItem:(DataPickerItem *)item;

- (BOOL)isSelectedItem:(DataPickerItem *)item;

@end
