//
//  NSString+Addition.h
//  LYY
//
//  Created by QS on 15/3/6.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
- (NSString *)first;
- (NSString *)last;
- (BOOL)isIntegerNumber;
- (NSInteger)toInteger;
+ (NSString *)fitConvertSize:(NSInteger)size;
- (CGSize)stringSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize;


- (NSString *)MD5Hash;
+ (NSString *)MD5HashOfData:(NSData *)data;
+ (NSString *)MD5HashOfFile:(NSString *)path;

+ (NSString *)mineTypeOfFile:(NSString *)path;

@end
