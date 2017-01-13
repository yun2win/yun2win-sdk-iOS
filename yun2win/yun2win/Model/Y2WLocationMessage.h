//
//  Y2WLocationMessage.h
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WLocationMessage : Y2WBaseMessage

/**
 *  经度
 */
@property (nonatomic, assign) double longitude;

/**
 *  纬度
 */
@property (nonatomic, assign) double latitude;

/**
 *  位置
 */
@property (nonatomic, copy) NSString *title;

/**
 *  
 */
@property (nonatomic, copy) NSString *thumImagepath;

@property (nonatomic, copy) NSString *thumImageUrl;

@end
