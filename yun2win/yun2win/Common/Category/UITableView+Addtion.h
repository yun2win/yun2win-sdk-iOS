//
//  UITableView+Addtion.h
//  API
//
//  Created by QS on 16/8/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Addtion)

- (NSIndexPath *)lastIndexPath;
- (BOOL)isVisibleLastIndexPath;
- (void)scrollToLastIndexPath:(BOOL)animate;

@end
