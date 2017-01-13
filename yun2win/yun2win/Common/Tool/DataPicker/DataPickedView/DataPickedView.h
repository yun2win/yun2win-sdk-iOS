//
//  DataPickedView.h
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickedViewTextCell.h"
#import "DataPickedViewImageCell.h"
@class DataPickedView;

@protocol DataPickedViewDelegate <NSObject>

- (void)dataPickedView:(DataPickedView *)view didSelectItem:(DataPickerItem *)item;

@end


@interface DataPickedView : UIView

@property (nonatomic, assign) BOOL avatar;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DataPickedViewDelegate>)delegate;

- (void)pushItem:(DataPickerItem *)item;

- (void)removeItem:(DataPickerItem *)item;

@end
