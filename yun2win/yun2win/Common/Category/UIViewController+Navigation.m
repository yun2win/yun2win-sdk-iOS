//
//  UIViewController+Navigation.m
//  API
//
//  Created by QS on 16/3/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

- (void)pushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController animated:YES hidesBottomBar:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self pushViewController:viewController animated:animated hidesBottomBar:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hidesBottomBar:(BOOL)hidden {
    viewController.hidesBottomBarWhenPushed = hidden;
    [self.navigationController pushViewController:viewController animated:animated];
}

@end
