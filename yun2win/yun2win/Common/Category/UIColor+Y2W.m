//
//  UIColor+Y2W.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UIColor+Y2W.h"

@implementation UIColor (Y2W)

+ (UIColor *)colorWithUID:(NSString *)uid {
    NSInteger asciiCode = 0;
    if (uid.length) asciiCode = [uid characterAtIndex:uid.length - 1];
    
    NSString *hexString = @[@"26D1CC",@"20D3A8",@"7DCF5D",@"FFC950",@"FD6774"][asciiCode%5];
    return [UIColor colorWithHexString:hexString];
}

+ (UIColor *)y2w_mainColor {
    return [UIColor colorWithHexString:@"21C0C0"];
}

+ (UIColor *)y2w_backgroundColor {
    return [UIColor colorWithHexString:@"E3EFEF"];
}

+ (UIColor *)y2w_atColor {
    return [UIColor colorWithRed:255/255.0 green:194/255.0 blue:97/255.0 alpha:1];
}

+ (UIColor *)y2w_blueColor {
    return [UIColor colorWithRed:0/255.0 green:163/255.0 blue:218/255.0 alpha:1];
}

+ (UIColor *)y2w_redColor {
    return [UIColor colorWithRed:237/255.0 green:85/255.0 blue:101/255.0 alpha:1];
}

@end
