//
//  SessionMemberModel.h
//  API
//
//  Created by QS on 16/3/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberModelInterface.h"

@interface SessionMemberModel : NSObject<MemberModelInterface>

@property (nonatomic, retain) NSMutableArray *members;

@property (nonatomic, retain) Y2WSessionMember *sessionMember;

- (instancetype)initWithSessionMember:(Y2WSessionMember *)sessionMember;

@end
