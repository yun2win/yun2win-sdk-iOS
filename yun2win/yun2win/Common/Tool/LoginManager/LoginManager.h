//
//  LoginManager.h
//  API
//
//  Created by QS on 16/8/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL logined;


+ (instancetype)sharedManager;

- (void)login;

- (void)logout;

@end
