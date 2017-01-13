//
//  MessageBase.h
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface MessageBase : RLMObject

@property NSString *sessionId;

@property NSString *ID;

@property NSString *content;

@property NSString *sender;

@property NSString *type;       // ["text"|"image"|"video"|"audio"|"file"|"location"|"task"|"av"]

@property NSString *status;     // ["storing"|"stored"|"storefailed"]

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property BOOL isDelete;

@property NSString *text;

@property NSString *searchText; // 额外添加用于搜索

@property BOOL showDate;        // 是否显示时间标签

@property float cellHeight;     // 单元格高度



- (NSDictionary *)toDict;

@end

RLM_ARRAY_TYPE(MessageBase)





@interface MessageFrame : RLMObject

+ (CGFloat)avatarSize;

+ (CGFloat)avatarMargin;

+ (CGFloat)timeStampHeight;

+ (CGFloat)textFontSize;

@end
