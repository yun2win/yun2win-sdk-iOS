//
//  UIView+Assignment.h
//  LYY
//
//  Created by QS on 15/2/3.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Assignment)

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, weak)  UIColor *borderColor;

@property (nonatomic, readonly) UIImage *screenshot;

/**
 *  在父视图内等比填充（超出部分会被裁剪）
 *
 *  @param size 自己的尺寸
 */
- (void)viewScaleAspectFill:(CGSize)size;

/**
 *  在父视图内居中显示
 *
 *  @param size 自己的尺寸
 */
- (void)viewScaleAspectFit:(CGSize)size;

- (UIImage *)screenShotWithFrame:(CGRect)rect;
@end
