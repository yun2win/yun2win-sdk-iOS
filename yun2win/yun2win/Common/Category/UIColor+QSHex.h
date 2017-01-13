//
//  UIColor+QSHex.h
//  LYY
//
//  Created by QS on 16/2/29.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QSHex)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *)hexString;

@end
