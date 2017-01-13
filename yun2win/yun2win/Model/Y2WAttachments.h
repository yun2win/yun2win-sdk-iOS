//
//  Y2WAttachments.h
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Y2WAttachment.h"

@interface Y2WAttachments : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;

- (Y2WAttachment *)getAttachmentById:(NSString *)ID;

- (void)getAttachmentById:(NSString *)ID success:(void (^)(Y2WAttachment *attachment))success failure:(void (^)(NSError *error))failure;




- (NSURLSessionDataTask *)uploadFile:(NSString *)path
                            progress:(ProgressBlock)progress
                             success:(void (^)(Y2WAttachment *attachment))success
                             failure:(void (^)(NSError *error))failure;

@end




@interface Y2WAttachmentsRemote : NSObject

/**
 *  初始化远程管理对象
 *
 *  @param Attachments 引用此对象的远程管理对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithAttachments:(Y2WAttachments *)attachments;

- (void)getAttachmentById:(NSString *)ID success:(void (^)(Y2WAttachment *attachment))success failure:(void (^)(NSError *error))failure;

@end








@interface UIImageView (Y2WAttachments)

- (void)y2w_setImageWithY2WURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end


@interface UIButton (Y2WAttachments)

- (void)y2w_setImageForState:(UIControlState)state withY2WURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end
