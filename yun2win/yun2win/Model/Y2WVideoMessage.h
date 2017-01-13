//
//  Y2WVideoMessage.h
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBaseMessage.h"
@class Y2WAttachment;

@interface Y2WVideoMessage : Y2WBaseMessage

@property (nonatomic, retain) Y2WAttachment *attachment;

@property (nonatomic, copy) NSString *attachmentId;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *thumImagePath;

@property (nonatomic, copy) NSString *thumImageUrl;

@end
