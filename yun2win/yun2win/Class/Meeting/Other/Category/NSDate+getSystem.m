//
//  NSDate+getSystem.m
//  ibama
//
//  Created by duanhongiang on 15/12/31.
//  Copyright © 2015年 ibama. All rights reserved.
//

#import "NSDate+getSystem.h"

@implementation NSDate (getSystem)

//获取系统日期
+ (NSString *)getSystemDate
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];

    NSString *dateStr = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld", (long)year, (long)month, (long)day];
    return dateStr;
}

//获取系统时间
+ (NSString *)getSystemTime
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld_%.2ld_%.2ld", (long)hour, (long)minute, (long)second];
    return timeStr;
}

//1970年时间戳转换成指定格式的时间
+ (NSString *)timestampToTime:(double)sec{
    NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:sec];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSArray *)getDataTimeArray{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger year=[comps year];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];

    NSMutableArray *dataTimeArray = [NSMutableArray arrayWithCapacity:0];
    [dataTimeArray addObject:[NSNumber numberWithInteger:year]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:month]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:week]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:day]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:hour]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:min]];
    [dataTimeArray addObject:[NSNumber numberWithInteger:sec]];

    return [dataTimeArray copy];
}


+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

//把指定的时间转换成1970年的时间戳
+ (NSString *)timeTotimestamp:(NSDate *)time{
    return [NSString stringWithFormat:@"%ld", (long)[time timeIntervalSince1970]];
}

@end
