//
//  Y2WImageMessage.h
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBaseMessage.h"
@class Y2WAttachment;

@interface Y2WImageMessage : Y2WBaseMessage

@property (nonatomic, retain) Y2WAttachment *attachment;

@property (nonatomic, copy) NSString *attachmentId;

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *thumImagePath;

@property (nonatomic, copy) NSString *thumImageUrl;

@end
