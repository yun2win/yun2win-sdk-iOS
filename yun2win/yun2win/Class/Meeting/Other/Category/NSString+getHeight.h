//
//  NSString+getHeight.h
//  page_test
//
//  Created by duanhongiang on 15/7/13.
//  Copyright (c) 2015年 ydhl-bjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (getHeight)

- (CGSize)getHeightWithFont:(UIFont *)font width:(CGFloat)width wordWap:(NSLineBreakMode)lineBreadMode;

@end
