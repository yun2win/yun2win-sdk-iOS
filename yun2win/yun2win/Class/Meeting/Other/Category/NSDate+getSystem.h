//
//  NSDate+getSystem.h
//  ibama
//
//  Created by duanhongiang on 15/12/31.
//  Copyright © 2015年 ibama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (getSystem)

//获取系统日期
+ (NSString *)getSystemDate;

//获取系统时间
+ (NSString *)getSystemTime;

//获取当前时间数组
+ (NSArray *)getDataTimeArray;

//1970年时间戳转换成指定格式的时间
+ (NSString *)timestampToTime:(double)sec;

//把指定的时间转换成1970年的时间戳
+ (NSString *)timeTotimestamp:(NSDate *)time;
@end
