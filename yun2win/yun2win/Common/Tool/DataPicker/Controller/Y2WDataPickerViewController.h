//
//  Y2WDataPickerViewController.h
//  yun2win
//
//  Created by QS on 16/9/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataPickerItem;

@interface Y2WDataPickerViewController : UIViewController

- (instancetype)initWithItems:(NSArray<DataPickerItem *> *)items;

@end
