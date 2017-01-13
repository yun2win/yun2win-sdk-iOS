//
//  CurrentUserBase.h
//  API
//
//  Created by QS on 16/9/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserBase.h"

@interface CurrentUserBase : UserBase

@property int expires;

@property NSString *appkey;

@property NSString *secret;

@property NSString *token;

@property NSString *password;

@property NSDate   *loginDate;

@end
