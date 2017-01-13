//
//  NSAttributedString+QSCommon.m
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSAttributedString+QSCommon.h"

@implementation NSAttributedString (QSCommon)

- (NSAttributedString *)setColor:(UIColor *)color forText:(NSString *)value {
    return [self.string setColor:color forText:value];
}

@end
