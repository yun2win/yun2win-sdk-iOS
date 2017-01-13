//
//  Y2WFileMessage.h
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBaseMessage.h"
@class Y2WAttachment;

@interface Y2WFileMessage : Y2WBaseMessage

@property (nonatomic, retain) Y2WAttachment *attachment;

@property (nonatomic, copy) NSString *attachmentId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger size;

@end
