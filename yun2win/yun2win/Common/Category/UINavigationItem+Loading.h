//
//  UINavigationItem+Loading.h
//  API
//
//  Created by QS on 16/3/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Loading)

/**
 *  开始加载动画
 */
- (void)startAnimating;

/**
 *  结束加载动画
 */
- (void)stopAnimating;

@end