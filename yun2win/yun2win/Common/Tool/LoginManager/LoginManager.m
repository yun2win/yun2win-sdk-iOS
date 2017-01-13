//
//  LoginManager.m
//  API
//
//  Created by QS on 16/8/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "LoginManager.h"

NSString *const Y2W_LG_ACCOUNT = @"Y2W_LG_ACCOUNT";
NSString *const Y2W_LG_PASSWORD = @"Y2W_LG_PASSWORD";
NSString *const Y2W_LG_LOGINED = @"Y2W_LG_LOGINED";


@implementation LoginManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static LoginManager *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[LoginManager alloc] init];
        instance.account = [[NSUserDefaults standardUserDefaults] objectForKey:Y2W_LG_ACCOUNT];
        instance.password = [[NSUserDefaults standardUserDefaults] objectForKey:Y2W_LG_PASSWORD];
        instance.logined = [[NSUserDefaults standardUserDefaults] boolForKey:Y2W_LG_LOGINED];
        
        
//        instance.account = @"qisong";
//        instance.password = @"111111";
//        [instance login];
    });
    return instance;
}

- (void)login {
    [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:Y2W_LG_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:Y2W_LG_PASSWORD];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Y2W_LG_LOGINED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logout {
//    self.account = nil;
    self.password = nil;
    self.logined = NO;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Y2W_LG_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Y2W_LG_PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Y2W_LG_LOGINED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
