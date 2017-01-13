//
//  ContactBase.h
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface ContactBase : RLMObject

@property NSString *userId;

@property NSString *ID;

@property NSString *name;

@property NSString *pinyin;

@property NSString *title;       // 备注

@property NSString *titlePinyin; // 备注的拼音

@property NSString *remark;

@property NSString *avatarUrl;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@property BOOL isDelete;

@property NSString *type;

@property NSString *extend;

@end

RLM_ARRAY_TYPE(ContactBase)
