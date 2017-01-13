//
//  UIViewController+Navigation.h
//  API
//
//  Created by QS on 16/3/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//



@interface UIViewController (Navigation)

- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hidesBottomBar:(BOOL)hidden;

@end
