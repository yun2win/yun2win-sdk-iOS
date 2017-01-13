//
//  DataPickedViewCell.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataPickerItem;

@protocol DataPickedViewCell <NSObject>

@property (nonatomic, retain) DataPickerItem *item;

@end
