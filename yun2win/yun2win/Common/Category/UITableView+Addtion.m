//
//  UITableView+Addtion.m
//  API
//
//  Created by QS on 16/8/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UITableView+Addtion.h"

@implementation UITableView (Addtion)

- (NSIndexPath *)lastIndexPath {
    if (!self.visibleCells.count) {
        return nil;
    }
    NSInteger section = self.numberOfSections - 1;
    NSInteger row = [self numberOfRowsInSection:section] - 1;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (BOOL)isVisibleLastIndexPath {
    return [self.indexPathsForVisibleRows.lastObject isEqual:[self lastIndexPath]];
}

- (void)scrollToLastIndexPath:(BOOL)animate {
    if (!self.visibleCells.count) {
        return;
    }

    [self scrollToRowAtIndexPath:[self lastIndexPath]
                atScrollPosition:UITableViewScrollPositionBottom
                        animated:animate];
}

@end