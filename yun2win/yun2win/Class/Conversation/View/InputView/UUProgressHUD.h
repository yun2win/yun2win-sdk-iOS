//
//  UUProgressHUD.h
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUProgressHUD : UIView

//@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

+ (void)show;

//+ (void)dismissWithSuccess:(UIImage *)image;
//
//+ (void)dismissWithError:(UIImage *)image;
//
//+ (void)changeImage:(UIImage *)image;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;

@end
