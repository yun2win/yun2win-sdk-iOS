//
//  Y2WAttachments.m
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WAttachments.h"

@interface Y2WAttachments ()

@property (nonatomic, retain, readwrite) Y2WAttachmentsRemote *remote;

@property (nonatomic, retain) NSCache *cache;

@end


@implementation Y2WAttachments

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.cache = [[NSCache alloc] init];
        self.remote = [[Y2WAttachmentsRemote alloc] initWithAttachments:self];
    }
    return self;
}

- (Y2WAttachment *)getAttachmentById:(NSString *)ID {
    Y2WAttachment *attachment = [self.cache objectForKey:ID];
    if (!attachment) {
        AttachmentBase *base = [AttachmentBase objectForPrimaryKey:ID];
        if (base) {
            attachment = [[Y2WAttachment alloc] initWithBase:base attachments:self];
            [self.cache setObject:attachment forKey:ID];
        }
    }
    return attachment;
}

- (void)getAttachmentById:(NSString *)ID success:(void (^)(Y2WAttachment *))success failure:(void (^)(NSError *))failure {
    Y2WAttachment *attachment = [self getAttachmentById:ID];
    if (attachment) {
        if (success) {
            success(attachment);
        }
        return;
    }
    [self.remote getAttachmentById:ID success:success failure:failure];
}






- (NSURLSessionDataTask *)uploadFile:(NSString *)path progress:(ProgressBlock)progress success:(void (^)(Y2WAttachment *))success failure:(void (^)(NSError *))failure {
    NSString *authorization = self.user.authorization;
    NSString *MD5Hash = [NSString MD5HashOfFile:path];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (authorization) headers[@"Authorization"] = authorization;
    if (MD5Hash) headers[@"Content-MD5"] = MD5Hash;

    return [HttpRequest UPLOADWithURL:[URL attachments] path:path headers:headers progress:progress success:^(NSDictionary *data) {
        [data setValue:path forKey:@"path"];
        Y2WAttachment *attachment = [[Y2WAttachment alloc] initWithDict:data];
        if (success) {
            success(attachment);
        }
    } failure:failure];
}


@end



@interface Y2WAttachmentsRemote ()

@property (nonatomic, weak) Y2WAttachments *attachments;

@end

@implementation Y2WAttachmentsRemote

- (instancetype)initWithAttachments:(Y2WAttachments *)attachments {
    if (self = [super init]) {
        self.attachments = attachments;
    }
    return self;
}


- (void)getAttachmentById:(NSString *)ID success:(void (^)(Y2WAttachment *))success failure:(void (^)(NSError *))failure {
    [HttpRequest GETWithURL:[URL attachments:ID] parameters:nil success:^(id data) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [AttachmentBase createOrUpdateInDefaultRealmWithValue:data];
        }];
        Y2WAttachment *attachment = [self.attachments getAttachmentById:ID];
        if (success) success(attachment);
    } failure:failure];
}

@end







@implementation NSURL (Y2WAttachments)

+ (NSURL *)URLWithY2WString:(NSString *)urlString {
    if (![urlString isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (![urlString isAbsolutePath]) {
        nil;
    }
    if (![urlString hasPrefix:@"http"]) {
        if ([urlString containsString:@"attachments"]) {
            urlString = [[URL baseURL] stringByAppendingPathComponent:urlString];
        }
    }
    return [NSURL URLWithString:urlString];
}

@end


@implementation UIImageView (Y2WAttachments)

- (void)y2w_setImageWithY2WURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    [SDWebImageManager.sharedManager.imageDownloader setValue:[Y2WUsers getInstance].getCurrentUser.authorization forHTTPHeaderField:@"Authorization"];
    [self sd_setImageWithURL:[NSURL URLWithY2WString:urlString] placeholderImage:placeholderImage];
}

@end


@implementation UIButton (Y2WAttachments)

- (void)y2w_setImageForState:(UIControlState)state withY2WURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    [SDWebImageManager.sharedManager.imageDownloader setValue:[Y2WUsers getInstance].getCurrentUser.authorization forHTTPHeaderField:@"Authorization"];
    [self sd_setImageWithURL:[NSURL URLWithY2WString:urlString]  forState:state placeholderImage:placeholderImage];
}

@end
