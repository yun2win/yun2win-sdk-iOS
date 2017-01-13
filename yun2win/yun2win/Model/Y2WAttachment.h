//
//  Y2WAttachment.h
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachmentBase.h"
@class Y2WAttachment,Y2WAttachments;

@protocol Y2WAttachmentDelegate <NSObject>

@optional;

- (void)attachmentWillDownload:(Y2WAttachment *)attachment;

- (void)attachment:(Y2WAttachment *)attachment downloadProgress:(CGFloat)progress;

- (void)attachmentDidDownload:(Y2WAttachment *)attachment;

@end


@interface Y2WAttachment : NSObject

@property (nonatomic, weak) Y2WAttachments *attachments;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *size;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) BOOL downloaded;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, retain) NSURLSessionDownloadTask *task;


- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWithBase:(AttachmentBase *)base attachments:(Y2WAttachments *)attachments;

- (void)addDelegate:(id<Y2WAttachmentDelegate>)delegate;
- (void)removeDelegate:(id<Y2WAttachmentDelegate>)delegate;


- (BOOL)isDownloaded;
- (void)download;

@end
