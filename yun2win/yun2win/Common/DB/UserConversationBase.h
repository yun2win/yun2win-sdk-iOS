//
//  UserConversationBase.h
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserConversationBase : RLMObject

@property NSString *ID;
@property NSString *targetId; // 本地添加，用于本地查询（type为p2p时为对方UserId,type为group时为群组的Id）
@property NSString *name;
@property NSString *type;     // "p2p", "single", "group","assistant"
@property NSString *avatarUrl;
@property NSDate   *createdAt;
@property NSDate   *updatedAt;
@property BOOL      isDelete;
@property BOOL      visiable;
@property BOOL      top; //置顶
@property int       unread;
@property NSString *text;
@property NSString *draft;
@property NSString *extend;

@property BOOL hidden;
@property NSString *subType;

@end

RLM_ARRAY_TYPE(UserConversationBase)
