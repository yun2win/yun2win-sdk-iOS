//
//  UIImage+Y2W.h
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Y2W)

- (UIImage *)imageWithScale:(float)scaleSize;

- (UIImage *)imageWithRect:(CGRect)rect;


+ (UIImage *)imageWithUIColor:(UIColor *)color;

+ (UIImage *)y2w_imageNamed:(NSString *)name;

+ (UIImage *)y2w_animatedGIFNamed:(NSString *)name;

+ (UIImage *)thumbnailOfVideo:(NSString *)videoPath;

- (NSString *)writePNG;

- (NSString *)writeJPGToQuality:(CGFloat)quality;

- (UIImage *)scaleToAvatar;

@end
