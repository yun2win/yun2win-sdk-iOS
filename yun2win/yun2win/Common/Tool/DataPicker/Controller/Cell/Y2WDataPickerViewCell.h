//
//  Y2WDataPickerViewCell.h
//  yun2win
//
//  Created by QS on 16/9/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickerItem.h"

@protocol Y2WDataPickerViewCell <NSObject>

@property (nonatomic, retain) DataPickerItem *item;

@property (nonatomic, copy) dispatch_block_t handler;


- (void)setItem:(DataPickerItem *)item handler:(dispatch_block_t)handler;

@end
