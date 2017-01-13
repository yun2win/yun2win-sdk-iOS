//
//  IMSession.m
//  API
//
//  Created by ShingHo on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "IMSession.h"


@implementation Y2WIMSessionMember
@synthesize uid = _uid;
@synthesize isDelete = _isDelete;

- (instancetype)initWithSessionMember:(Y2WSessionMember *)member {
    if (self = [super init]) {
        self.uid = member.userId;
        self.isDelete = member.isDelete;
    }
    return self;
}

@end





@implementation IMSession
@synthesize ID = _ID;
@synthesize mts = _mts;
@synthesize force = _force;
@synthesize members = _members;

- (instancetype)initWithSession:(Y2WSession *)session {
    return [self initWithSession:session needMembers:NO beginTime:0 force:NO];
}

- (instancetype)initWithSession:(Y2WSession *)session needMembers:(BOOL)needMembers beginTime:(NSTimeInterval)time force:(BOOL)force {
    if (self = [super init]) {
        self.ID = [NSString stringWithFormat:@"%@_%@",session.type,session.ID];
        self.mts = session.createMTS.y2w_toMTS;
        self.force = force;
        
        if (needMembers) {
            NSMutableArray *imMembers = [NSMutableArray array];
            NSArray *members = [session.members getAllMembers];
            for (Y2WSessionMember *member in members) {
                if (force) {
                    [imMembers addObject:[[Y2WIMSessionMember alloc] initWithSessionMember:member]];
                    
                }else if (!time) {
                    if (!member.isDelete) {
                        [imMembers addObject:[[Y2WIMSessionMember alloc] initWithSessionMember:member]];
                    }
                    
                }else {
                    if (member.updatedAt.y2w_toMTS > time) {
                        [imMembers addObject:[[Y2WIMSessionMember alloc] initWithSessionMember:member]];
                    }
                }
            }
            self.members = imMembers;
        }
    }
    return self;
}

- (instancetype)initWithY2wIMAppUID:(NSString *)uid needMembers:(BOOL)needMembers {
    if (self = [super init]) {
        self.ID = [NSString stringWithFormat:@"%@_%@",Y2W_IM_APPT_YPE,uid];
        self.mts = Y2W_IM_APPT_YPE_MTS;
        
        if (needMembers) {
            Y2WIMSessionMember *member = [[Y2WIMSessionMember alloc] init];
            member.uid = uid;
            member.isDelete = false;
            self.members = @[member];
        }
    }
    return self;
}

@end
