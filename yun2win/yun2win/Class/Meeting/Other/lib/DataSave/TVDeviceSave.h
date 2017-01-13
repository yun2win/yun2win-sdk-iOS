//
//  TVDeviceSave.h
//  yun2win
//
//  Created by duanhl on 16/11/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyTVModel;

@interface TVDeviceSave : NSObject

//保存一个TV
+ (void)DataSave:(MyTVModel *)model;

//获取所有的TV
+ (NSArray *)getAllTV;

//删除-个TV数据
+ (void)DataDelete:(NSString *)ID;

//修改TV名称
//+ (void)DataDeviceId:(NSString *)ID nickName:(NSString *)nickName;

@end
