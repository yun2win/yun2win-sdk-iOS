//
//  Y2WAttachment.m
//  API
//
//  Created by QS on 16/9/12.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WAttachment.h"

@interface Y2WAttachment ()

@property (nonatomic, retain) MulticastDelegate<Y2WAttachmentDelegate> *delegates;

@end

@implementation Y2WAttachment

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"fileName"];
        self.md5 = dict[@"md5"];
        //        self.url = [[URL attachmentsOfContent:self.ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.url = [[[URL attachments] stringByAppendingFormat:@"/%@/%@",self.ID,self.md5] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.path = dict[@"path"];
    }
    return self;
}

- (instancetype)initWithBase:(AttachmentBase *)base attachments:(Y2WAttachments *)attachments {
    if (self = [super init]) {
        self.delegates = [[MulticastDelegate<Y2WAttachmentDelegate> alloc] init];
        self.attachments = attachments;
        self.ID = base.ID;
        self.name = base.name;
        self.md5 = base.md5;
        self.downloaded = [base.status isEqualToString:@"downloaded"];
        self.path = [NSString attachmentPathForID:self.ID name:self.name];
        self.url = [[[URL attachments] stringByAppendingFormat:@"/%@/%@",self.ID,self.md5] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}
- (void)addDelegate:(id<Y2WAttachmentDelegate>)delegate {
    [self.delegates removeDelegate:delegate];
    [self.delegates addDelegate:delegate];
}
- (void)removeDelegate:(id<Y2WAttachmentDelegate>)delegate {
    [self.delegates removeDelegate:delegate];
}

- (BOOL)isDownloaded {
    return [self.path isPathExsit] && self.downloaded;
}
- (void)download {
    if (self.task) {
        return;
    }
    self.downloaded = NO;
    NSDictionary *headers = @{@"Authorization": self.attachments.user.authorization};
    
    self.task = [HttpRequest DOWNLOADWithURL:self.url path:self.path headers:headers progress:^(CGFloat progress) {
        self.progress = progress;
        if ([self.delegates respondsToSelector:@selector(attachment:downloadProgress:)]) {
            [self.delegates attachment:self downloadProgress:progress];
        }
    } success:^(NSURL *url) {
        self.task = nil;
        self.downloaded = YES;
        if ([self.delegates respondsToSelector:@selector(attachmentDidDownload:)]) {
            [self.delegates attachmentDidDownload:self];
        }
    } failure:^(NSError *error) {
        self.task = nil;
        NSLog(@"%@",error.message);
    }];
    if ([self.delegates respondsToSelector:@selector(attachmentWillDownload:)]) {
        [self.delegates attachmentWillDownload:self];
    }
}






#pragma mark - setter

- (void)setDownloaded:(BOOL)downloaded {
    _downloaded = downloaded;
    
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        AttachmentBase *base = [AttachmentBase objectForPrimaryKey:self.ID];
        base.status = downloaded ? @"downloaded" : @"downloadfailed";
    }];
}


@end
