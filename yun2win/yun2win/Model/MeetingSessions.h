//
//  MeetingSessions.h
//  yun2win
//
//  Created by duanhl on 16/11/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WCurrentUser;
@class Y2WSessionsRemote;

@interface MeetingSessions : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;
@property (nonatomic, retain) Y2WSessionsRemote *remote;



//创建会议
+ (NSDictionary *)createDicName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose;


//创建会议
+ (void)addMeetingName:(NSString *)name type:(NSString *)type mode:(int)mode startTime:(NSString *)startTime endTime:(NSString *)endTime remark:(NSString *)remark period:(int)period isClose:(BOOL)isClose success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure;


@end
