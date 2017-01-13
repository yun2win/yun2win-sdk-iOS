//
//  SessionMemberPickerConfig.h
//  API
//
//  Created by ShingHo on 16/5/11.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPickerConfig.h"
@class Y2WSession;
@interface SessionMemberPickerConfig : NSObject<UserPickerConfig>

@property (nonatomic, strong) Y2WSession *session;

- (instancetype)initWithSession:(Y2WSession *)session;

@end
