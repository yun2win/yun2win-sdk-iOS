//
//  UIAlertView+Addition.m
//  API
//
//  Created by QS on 16/3/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UIAlertView+Addition.h"

@implementation UIAlertView (Addition)

+ (void)showTitle:(NSString *)title message:(NSString *)message {
    if ([message isKindOfClass:[NSDictionary class]]) {
        message = [(NSDictionary *)message toJsonString];
    }
    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    });
}

@end
