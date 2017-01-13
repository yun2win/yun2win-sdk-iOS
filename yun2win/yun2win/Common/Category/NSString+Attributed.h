//
//  NSString+Attributed.h
//  LYY
//
//  Created by QS on 15/1/24.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Attributed)

- (NSMutableAttributedString *)stringForAttributedString;
- (NSString *)showNameReplaceSendName;
- (CGSize)sizeAttributedWithWidth:(CGFloat)width;
- (NSArray *)findValue:(NSString *)value;
- (NSArray *)findLink;
- (NSArray *)findLinkURL;
- (BOOL)isLink;
- (BOOL)isTask;

- (NSAttributedString *)setColor:(UIColor *)color forText:(NSString *)value;

@end
