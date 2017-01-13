//
//  AttachmentBase.h
//  yun2win
//
//  Created by QS on 16/10/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Realm/Realm.h>

@interface AttachmentBase : RLMObject

@property NSString *ID;

@property NSString *name;

@property NSString *size;

@property NSString *md5;

@property NSString *url;

@property NSString *status;

@property NSDate *createdAt;

@property NSDate *updatedAt;

@end
