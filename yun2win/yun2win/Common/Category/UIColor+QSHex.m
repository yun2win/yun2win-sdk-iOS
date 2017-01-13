//
//  UIColor+QSHex.m
//  LYY
//
//  Created by QS on 16/2/29.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import "UIColor+QSHex.h"

@implementation UIColor (QSHex)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (hexString.length == 3) {
        NSString *sub1 = [hexString substringWithRange:NSMakeRange(0, 1)];
        NSString *sub2 = [hexString substringWithRange:NSMakeRange(1, 1)];
        NSString *sub3 = [hexString substringWithRange:NSMakeRange(2, 1)];
        hexString = [NSString stringWithFormat:@"%@%@%@%@%@%@",sub1,sub1,sub2,sub2,sub3,sub3];
    }
    
    if (hexString.length != 6) {
        return nil;
    }
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    
    if (match != 0) return nil;
    
    
    NSRange rRange = NSMakeRange(0, 2);
    NSString *rComponent = [hexString substringWithRange:rRange];
    unsigned rVal = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
    [rScanner scanHexInt:&rVal];
    float rRetVal = (float)rVal / 255;
    
    NSRange gRange = NSMakeRange(2, 2);
    NSString *gComponent = [hexString substringWithRange:gRange];
    unsigned gVal = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
    [gScanner scanHexInt:&gVal];
    float gRetVal = (float)gVal / 255;
    
    NSRange bRange = NSMakeRange(4, 2);
    NSString *bComponent = [hexString substringWithRange:bRange];
    unsigned bVal = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
    [bScanner scanHexInt:&bVal];
    float bRetVal = (float)bVal / 255;
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:1.0f];
    
}

- (NSString *)hexString {
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    return [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec].uppercaseString;
}

@end
