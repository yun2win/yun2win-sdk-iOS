//
//  UserModel.h
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortGroupInterface.h"
#import "MemberModelInterface.h"

@interface UserModel : NSObject<MemberModelInterface>

@property (nonatomic, retain) NSMutableArray *members;

@property (nonatomic, retain) Y2WUser *user;

- (instancetype)initWithUser:(Y2WUser *)user;

@end
