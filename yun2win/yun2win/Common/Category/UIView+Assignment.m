//
//  UIView+Assignment.m
//  LYY
//
//  Created by QS on 15/2/3.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import "UIView+Assignment.h"
#import <AVFoundation/AVUtilities.h>
@implementation UIView (Assignment)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}


- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}



- (void)viewScaleAspectFill:(CGSize)size {
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(self.superview.bounds.size,CGRectMake(0, 0, size.width, size.height));
    CGFloat rate = rect.size.width/self.superview.bounds.size.width;

    self.frame = CGRectMake(0, 0, size.width/rate, size.height/rate);
    self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
}

- (void)viewScaleAspectFit:(CGSize)size {
    self.frame = AVMakeRectWithAspectRatioInsideRect(size,self.superview.bounds);
}




- (UIImage*)screenshot {
    CGRect frame = [self bounds];
    UIGraphicsBeginImageContextWithOptions(frame.size,NO,[UIScreen mainScreen].scale);
    
    for(UIView *subview in self.subviews) {
        if (subview.isHidden) continue;
        [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:NO];
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)screenShotWithFrame:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,[UIScreen mainScreen].scale);
    
    for(UIView *subview in self.subviews) {
        if (subview.isHidden) continue;
        [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:NO];
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
