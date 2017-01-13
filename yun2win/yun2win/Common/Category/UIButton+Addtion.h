//
//  UIButton+Addtion.h
//  API
//
//  Created by QS on 16/9/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (QSblock)

- (void)addHandler:(void(^)(UIButton *button))block;

@end




@interface UIButton (QSProgress)

@property (nonatomic, assign) BOOL showProgress;

@property (nonatomic, assign) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
