//
//  UserPickerViewController.h
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPickerConfig.h"
#import "MemberModelInterface.h"


typedef void(^UserPickerCallBackBlock)(NSArray<NSObject<MemberModelInterface> *> *members);

@interface UserPickerViewController : UIViewController

- (instancetype)initWithConfig:(NSObject<UserPickerConfig> *)config;

- (void)selectMembersCompletion:(UserPickerCallBackBlock)block cancel:(void(^)(void))cancel;

@end
