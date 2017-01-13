//
//  NSString+getHeight.m
//  page_test
//
//  Created by duanhongiang on 15/7/13.
//  Copyright (c) 2015年 ydhl-bjc. All rights reserved.
//

#import "NSString+getHeight.h"

@implementation NSString (getHeight)

- (CGSize)getHeightWithFont:(UIFont *)font width:(CGFloat)width wordWap:(NSLineBreakMode)lineBreadMode
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreadMode;
        
        NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        if (size.width > -fabs(0.000001) && size.width < fabs(0.000001))
        {
            size.height = 0.0f;
        }
        
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreadMode];
    }
    
    return size;
}
@end
