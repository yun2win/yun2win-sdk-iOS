//
//  ThemeManager.m
//  API
//
//  Created by QS on 16/3/11.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static ThemeManager *instance;

    dispatch_once(&onceToken, ^{
        instance = [[ThemeManager alloc] init];
    });
    return instance;
}

- (void)defaultTheme {
    self.currentColor = [UIColor y2w_mainColor];
}

- (void)update {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = self.currentColor;
    [UINavigationBar appearance].translucent = YES;
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    
    [UITabBar appearance].tintColor = self.currentColor;
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
  
    [UIToolbar appearance].tintColor = self.currentColor;

    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            for (UIView *view in window.subviews) {
                [view removeFromSuperview];
                [window addSubview:view];
            }
        }
    });
}





#pragma mark - ———— setter ———— -

- (void)setCurrentColor:(UIColor *)currentColor {
    if ([_currentColor isEqual:currentColor]) {
        return;
    }
    _currentColor = currentColor;
    [self update];
}

@end
