//
//  UINavigationController+autoRotate.h
//  yun2win
//
//  Created by duanhl on 16/12/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (autoRotate)

- (BOOL)shouldAutorotate;

- (UIInterfaceOrientationMask)supportedInterfaceOrientations;

@end
