//
//  Y2WBaseMessage.h
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WMessages;

@interface Y2WBaseMessage : NSObject

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSDictionary *content;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *updatedAt;

@property (nonatomic, assign) CGFloat cellHeight;   // 单元格高度

@property (nonatomic, assign) BOOL isShowTimestamp; // 是否显示时间标签

@property (nonatomic, copy) NSArray *users;         // @的所有用户

@property (nonatomic, assign) BOOL byTheAt;         // 是否被@了


+ (instancetype)createMessageWithDict:(NSDictionary *)dict;

- (void)updateWithDict:(NSDictionary *)dict;






#pragma mark - Helper -

- (BOOL)isUploadFile;

@end
