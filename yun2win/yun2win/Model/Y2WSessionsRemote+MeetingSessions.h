//
//  Y2WSessionsRemote+MeetingSessions.h
//  yun2win
//
//  Created by duanhl on 16/11/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSessions.h"

@interface Y2WSessionsRemote (MeetingSessions)

//创建会议
+ (NSDictionary *)createDicName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose;

//创建会议
- (void)addMeetingName:(NSString *)name mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose userArray:(NSArray *)userArray success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure;

//添加成员
- (void)addMeetingUser:(NSArray *)userArray enter:(BOOL)enter session:(Y2WSession *)session success:(void (^)(void))success failure:(void (^)(NSError *))failure;


- (NSArray *)getMeetingList;

@end
