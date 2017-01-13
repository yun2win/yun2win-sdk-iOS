//
//  UINavigationController+autoRotate.m
//  yun2win
//
//  Created by duanhl on 16/12/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UINavigationController+autoRotate.h"

@implementation UINavigationController (autoRotate)
#pragma mark 适配横竖屏
- (BOOL)shouldAutorotate
{
    return [self.viewControllers.firstObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.viewControllers.firstObject supportedInterfaceOrientations];
}

@end
