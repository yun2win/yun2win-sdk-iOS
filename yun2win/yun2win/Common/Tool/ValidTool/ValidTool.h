//
//  ValidTool.h
//  珠宝库
//
//  Created by vooda001 on 15/8/6.
//  Copyright (c) 2015年 vooda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidTool : NSObject

//验证是否手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//验证邮箱合法性
+ (BOOL)isValidateEmail:(NSString *)email;


//获取当前时间簇
+ (NSString *)getNowTimec;

//md5加密
+ (NSString *)md5:(NSString *)str;

//设置高度
+ (CGFloat)getHeightWithString:(NSString *)str fontsize:(CGFloat)fontsize width:(CGFloat)width;

//设置宽度
+ (CGFloat)getWidthtWithString:(NSString *)str fontsize:(CGFloat)fontsize;



@end
