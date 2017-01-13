//
//  SessionsInfoChangedViewController.h
//  API
//
//  Created by ShingHo on 16/4/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionsInfoChangedViewController : UIViewController

- (instancetype)initWithUserSession:(Y2WSession *)session changedType:(NSString *)type;

@end
