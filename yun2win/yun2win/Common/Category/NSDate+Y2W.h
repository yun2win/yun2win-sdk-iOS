//
//  NSDate+Y2W.h
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Y2W)

+ (NSDate *)dateWithMTS:(NSTimeInterval)mts;

- (NSString *)y2w_toString;

- (NSTimeInterval)y2w_toMTS;

@end



@interface NSString (Y2W)

- (NSDate *)y2w_toDate;

- (NSTimeInterval)y2w_toMTS;

@end
