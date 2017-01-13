//
//  ThemeManager.h
//  API
//
//  Created by QS on 16/3/11.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

@property (nonatomic, retain) UIColor *currentColor;

+ (instancetype)sharedManager;

- (void)defaultTheme;

@end
