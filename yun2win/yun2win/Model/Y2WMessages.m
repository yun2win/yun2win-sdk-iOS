//
//  Y2WMessages.m
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WMessages.h"
#import "Y2WSession.h"
#import "MulticastDelegate.h"
#import <objc/runtime.h>
#import "Y2WTextMessage.h"
#import "Y2WImageMessage.h"
#import "FileAppend.h"
#import "Y2WSyncManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MessageBase.h"

@interface Y2WMessages ()

@property (nonatomic, retain) MulticastDelegate<Y2WMessagesDelegate> *delegates;

@property (nonatomic, retain) NSMutableSet *messageList;

@end



@implementation Y2WMessages

#pragma mark - ———— 初始化 ———— -

- (instancetype)initWithSession:(Y2WSession *)session {
    if (self = [super init]) {
        self.session = session;
        self.remote = [[Y2WMessagesRemote alloc] initWithMessages:self];
        self.delegates = [[MulticastDelegate<Y2WMessagesDelegate> alloc] init];
        
        // 清理发送中状态
        RLMResults *results = [MessageBase objectsInRealm:self.session.sessions.user.realm where:@"sessionId == %@ AND status == %@",self.session.ID, @"storing"];
        [self.session.sessions.user.realm transactionWithBlock:^{
            [results setValue:@"storefailed" forKey:@"status"];
        }];
    }
    return self;
}


#pragma mark - ———— Y2WMessageDelegateInterface ———— -

- (void)addDelegate:(id<Y2WMessagesDelegate>)delegate {
 
    [self.delegates addDelegate:delegate];
    if (self.remote.syncManager.isFinishedFirstSync && [delegate respondsToSelector:@selector(messages:didFistSyncWithError:)]) {
        [delegate messages:self didFistSyncWithError:nil];
    }
}

- (void)removeDelegate:(id<Y2WMessagesDelegate>)delegate {

    [self.delegates removeDelegate:delegate];
}

- (void)loadMessageFromDelegate:(id<Y2WMessagesDelegate>)delegate {
    // todo 如果已经同步完成直接回调
    [self.remote sync];
}

- (void)sendMessage:(Y2WBaseMessage *)message {
    [self willSendMessage:message];
    
    if (message.isUploadFile) {
        [self storeFileMessage:message success:^(Y2WBaseMessage *message) {
            [self storeMessage:message];
        }];
    }
    else{
        [self storeMessage:message];
    }
}


- (void)storeMessage:(Y2WBaseMessage *)message {
    [self.remote storeMessages:message success:^(Y2WBaseMessage *message) {
        RLMRealm *realm = self.session.sessions.user.realm;
        MessageBase *base = [MessageBase objectInRealm:realm forPrimaryKey:message.ID];
        if (base) {
            [realm transactionWithBlock:^{
                [realm deleteObject:base];
            }];
        }
        
        [self.session.sessions.user.userConversations.remote sync:^{
            [self.remote sync];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        RLMRealm *realm = self.session.sessions.user.realm;
        [realm transactionWithBlock:^{
            MessageBase *base = [MessageBase objectInRealm:realm forPrimaryKey:message.ID];
            base.status = @"storefailed";
        }];
        [self sendMessage:message didCompleteWithError:error];
    }];
}



#pragma mark - ———— 所有回调操作（防止顺序不对，统一在一个串行队列执行） ———— -

- (void)willSendMessage:(Y2WBaseMessage *)message {
    if ([self.delegates respondsToSelector:@selector(messages:willSendMessage:)]) {
        [self.delegates messages:self willSendMessage:message];
    }
}

- (void)sendMessage:(Y2WBaseMessage *)message didCompleteWithError:(NSError *)error {
    if ([self.delegates respondsToSelector:@selector(messages:sendMessage:didCompleteWithError:)]) {
        [self.delegates messages:self sendMessage:message didCompleteWithError:error];
    }
}





- (void)storeFileMessage:(Y2WBaseMessage *)message success:(void(^)(Y2WBaseMessage *message))success
{
    FileAppend *append;
    FileAppend *thumAppend;
    NSArray *appends;
    if ([message.type isEqualToString:@"image"]) {
        Y2WImageMessage *imgMessage = (Y2WImageMessage *)message;
        append = [FileAppend fileAppendWithFilePath:imgMessage.imagePath name:@"file" fileName:[NSString stringWithFormat:@"IMG_%@.jpeg", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"image/png"];
        thumAppend = [FileAppend fileAppendWithFilePath:imgMessage.thumImagePath name:@"file" fileName:[NSString stringWithFormat:@"thumIMG_%@.jpeg", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"image/png"];
        appends = @[append,thumAppend];
    }
    else if([message.type isEqualToString:@"video"])
    {
        Y2WVideoMessage *videoMessage = (Y2WVideoMessage *)message;
        append = [FileAppend fileAppendWithFilePath:videoMessage.videoPath name:@"file" fileName:[NSString stringWithFormat:@"video_%@.mp4", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"video/mp4"];
        thumAppend = [FileAppend fileAppendWithFilePath:videoMessage.thumImagePath name:@"file" fileName:[NSString stringWithFormat:@"thumIMG_%@.jpeg", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"image/png"];
        appends = @[append,thumAppend];
    }
    else if ([message.type isEqualToString:@"audio"])
    {
        Y2WAudioMessage *audioMessage = (Y2WAudioMessage *)message;
        append = [FileAppend fileAppendWithFilePath:audioMessage.audioPath name:@"file" fileName:[NSString stringWithFormat:@"audio_%@.aac", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"audio/mpeg"];
        appends = @[append];
    }
    else if ([message.type isEqualToString:@"location"])
    {
        Y2WLocationMessage *locationMessage = (Y2WLocationMessage *)message;
        thumAppend = [FileAppend fileAppendWithFilePath:locationMessage.thumImagepath name:@"file" fileName:[NSString stringWithFormat:@"thumIMG_%@.jpeg", @([NSDate timeIntervalSinceReferenceDate])] mimeType:@"image/png"];
        appends = @[thumAppend];
    }
    
    [self.remote uploadFile:appends progress:^(CGFloat fractionCompleted) {

    } success:^(NSArray *fileArray) {
//        NSLog(@"file 4.21 : %@",fileArray);
        if ([message.type isEqualToString:@"image"]) {
            NSString *src = [URL attachmentsOfContentWithNoHeader:fileArray[0][@"id"]];
            NSString *thumbnail = [URL attachmentsOfContentWithNoHeader:fileArray[1][@"id"]];
            message.content = @{@"src":src,
                                @"thumbnail":thumbnail,
                                @"width":message.content[@"width"],
                                @"height":message.content[@"height"]};
        }
        if ([message.type isEqualToString:@"video"]) {
            NSString *src = [URL attachmentsOfContentWithNoHeader:fileArray[0][@"id"]];
            NSString *thumbnail = [URL attachmentsOfContentWithNoHeader:fileArray[1][@"id"]];
            message.content = @{@"src":src,
                                @"thumbnail":thumbnail,
                                @"width":message.content[@"width"],
                                @"height":message.content[@"height"]};
        }
        if ([message.type isEqualToString:@"location"])
        {
            NSString *thumbnail = [URL attachmentsOfContentWithNoHeader:fileArray[0][@"id"]];
            message.content = @{@"thumbnail":thumbnail,
                                @"width":message.content[@"width"],
                                @"height":message.content[@"height"],
                                @"longitude":message.content[@"longitude"],
                                @"latitude":message.content[@"latitude"],
                                @"title":message.content[@"title"]};
        }
        if ([message.type isEqualToString:@"audio"]) {
            NSString *thumbnail = [URL attachmentsOfContentWithNoHeader:fileArray[0][@"id"]];
            message.content = @{@"src":thumbnail,
                                @"second":message.content[@"second"]};

        }
        if ([message.type isEqualToString:@"file"]) {
            NSString *thumbnail = [URL attachmentsOfContentWithNoHeader:fileArray[0][@"id"]];
            message.content = @{@"src":thumbnail,
                                @"name":message.content[@"name"],
                                @"size":message.content[@"size"]};
            
        }
        
        if (success)    success(message);
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error);
    }];
}

- (NSString *)storeLocalFileWithPath:(NSString *)filePath type:(NSString *)type
{
    NSString *fileName;
    if ([type isEqualToString:@"audio"]) {
        fileName = [NSString stringWithFormat:@"audio_%@.aac",@([NSDate timeIntervalSinceReferenceDate])];
    }
    NSString *path = [NSString getDocumentPath:fileName Type:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [data writeToFile:path atomically:YES];
    return path;
}

#pragma mark - ———— 消息构造 ———— -

- (Y2WAVMessage *)avMessageWithContent:(NSDictionary *)content {
    Y2WAVMessage *message = [[Y2WAVMessage alloc] init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"av";
    message.status = @"storing";
    message.content = content;
    message.ID = [NSUUID UUID].UUIDString;
    return message;
}

- (Y2WTextMessage *)messageWithText:(NSString *)text {
    Y2WTextMessage *message = [[Y2WTextMessage alloc]init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"text";
    message.status = @"storing";
    if ([text isTask]) {
        message.type = @"task";
        text = [text stringByReplacingOccurrencesOfString:@"/task" withString:@"【任务】"];
    }
    message.content = @{@"text": text};
    message.text = text;
    message.ID = [NSUUID UUID].UUIDString;
    return message;
}

- (Y2WImageMessage *)messageWithImage:(UIImage *)image
{
    Y2WImageMessage *message = [[Y2WImageMessage alloc]init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"image";
    message.status = @"storing";
    message.imagePath = [image writeJPGToQuality:0.5];
    message.thumImagePath = [image writeJPGToQuality:0.1];
    message.ID = [NSUUID UUID].UUIDString;
    message.content = @{@"width":[NSString stringWithFormat:@"%lf",image.size.width*0.1],
                        @"height":[NSString stringWithFormat:@"%lf",image.size.height*0.1]};
    return message;
}

- (Y2WVideoMessage *)messageWithVideoPath:(NSString *)videoPath
{
    Y2WVideoMessage *message = [[Y2WVideoMessage alloc]init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"video";
    message.status = @"storing";
    
    message.videoPath = videoPath;
    UIImage *image = [UIImage thumbnailOfVideo:videoPath];
//    if (image == nil) return nil;
    NSString *thumImgPath = [image writeJPGToQuality:0.1];

    message.thumImagePath = thumImgPath;
    message.content = @{@"width": @([@(image.size.width) integerValue]).stringValue,
                        @"height":@([@(image.size.height) integerValue]).stringValue,
                        @"name":[NSString stringWithFormat:@"y2w%@.mp4",[NSUUID UUID].UUIDString]};
    
    return message;
}

//- (Y2WFileMessage *)messageWithFilePath:(FileModel *)model
//{
//    Y2WFileMessage *message = [[Y2WFileMessage alloc]init];
//    message.sessionId = self.session.ID;
//    message.sender = self.session.sessions.user.ID;
//    message.type = @"file";
//    message.status = @"storing";
//    
//    message.filePath = model.path;
//    NSData *file = [NSData dataWithContentsOfFile:model.path];
//    message.size = @(file.length).stringValue;
//    message.content = @{@"src":model.path,
//                        @"name":model.title,
//                        @"size":@(file.length)};
//    return message;
//}

- (Y2WLocationMessage *)messageWithLocationPoint:(LocationPoint *)locationPoint
{
    Y2WLocationMessage *message = [[Y2WLocationMessage alloc]init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"location";
    message.status = @"storing";
    
    message.thumImagepath = locationPoint.imagePath;
    message.longitude = locationPoint.coordinate.longitude;
    message.latitude = locationPoint.coordinate.latitude;
    message.title = locationPoint.title;
    
    message.content = @{@"width":@(locationPoint.image.size.width),
                        @"height":@(locationPoint.image.size.height),
                        @"longitude":@(locationPoint.coordinate.longitude),
                        @"latitude":@(locationPoint.coordinate.latitude),
                        @"title":message.title ?: @""};
    return message;
}

- (Y2WAudioMessage *)messageWithAudioPath:(NSString *)audioPath timer:(NSInteger)audioTimer
{
    
    Y2WAudioMessage *message = [[Y2WAudioMessage alloc]init];
    message.sessionId = self.session.ID;
    message.sender = self.session.sessions.user.ID;
    message.type = @"audio";
    message.status = @"storing";
    
    NSString *path = [self storeLocalFileWithPath:audioPath type:message.type];
    message.audioPath = path;
    message.audioTimer = audioTimer;
    message.content = @{@"second":@(audioTimer)};
    return message;

}

@end








@interface Y2WMessagesRemote ()<Y2WSyncManagerDelegate>

@property (nonatomic, weak) Y2WMessages *messages;

@end



@implementation Y2WMessagesRemote

- (instancetype)initWithMessages:(Y2WMessages *)messages {
    
    if (self = [super init]) {
        self.messages = messages;
        self.syncManager = [[Y2WSyncManager alloc] initWithDelegate:self currentUser:self.messages.session.sessions.user url:[URL acquireMessages:self.messages.session.ID]];
    }
    return self;
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncFirstForData:(NSDictionary *)data onError:(NSError *)error {
    if ([self.messages.delegates respondsToSelector:@selector(messages:didFistSyncWithError:)]) {
        [self.messages.delegates messages:self.messages didFistSyncWithError:error];
    }
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncForData:(NSDictionary *)data {
    if (![self.messages.session.updatedAt isEqualToString:data[@"sessionUpdatedAt"]]) {
        Y2WSession *session = self.messages.session;
        [session.sessions.remote getSessionWithTargetId:session.targetId type:session.type success:nil failure:nil];
    }
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncOnceForDatas:(NSArray *)datas {
    __block BOOL needSendSyncMemberMessage = NO;
    
    RLMRealm *realm = self.messages.session.sessions.user.realm;
    [realm transactionWithBlock:^{
        for (NSDictionary *data in datas) {
            // 查找是否有新消息
            if (!needSendSyncMemberMessage) {
                MessageBase *oldMessage = [MessageBase objectInRealm:realm forPrimaryKey:data[@"id"]];
                if (!oldMessage && ![data[@"sender"] isEqualToString:self.messages.session.sessions.user.ID]) {
                    needSendSyncMemberMessage = YES;
                }
            }
            
            MessageBase *message = [MessageBase createOrUpdateInRealm:realm withValue:data];
            message.sessionId = self.messages.session.ID;
        }
    }];
    
    // 如果有新消息则发送同步命令
    if (needSendSyncMemberMessage) {
        [self.messages.session.userConversation.userConversations.remote sync:nil];
        IMSession *imSession = [[IMSession alloc] initWithSession:self.messages.session];
        [self.messages.session.sessions.user.bridge sendMessages:@[@{@"type":@(Y2WSyncTypeSessionMember), @"sessionId": imSession.ID}] toSession:imSession];
    }
}



- (void)sync {
    if (self.messages.delegates.count) {
        [self.messages.session.userConversation clearUnRead];
        [self.syncManager sync];
    }
}



- (void)storeMessages:(Y2WBaseMessage *)message success:(void (^)(Y2WBaseMessage *message))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"type":message.type,@"content":[message.content toJsonString],@"sender":message.sender};
    [HttpRequest POSTWithURL:[URL acquireMessages:self.messages.session.ID] parameters:parameters success:^(id data) {
        IMSession *imSession = [[IMSession alloc] initWithSession:self.messages.session];
        [self.messages.session.sessions.user.bridge sendMessages:@[@{@"type":@(Y2WSyncTypeUserConversation)},
                                                                   @{@"type":@(Y2WSyncTypeMessage), @"sessionId": imSession.ID}]
                                                     pushMessage:@{@"msg": @"您有一条新消息"}
                                                       toSession:imSession];
        if (success) success(message);
    } failure:failure];
}

- (void)updataMessage:(Y2WBaseMessage *)message session:(Y2WSession *)session success:(void (^)(Y2WBaseMessage *))success failure:(void (^)(NSError *))failure {
    [HttpRequest PUTWithURL:[URL aboutMessage:message.ID Session:message.sessionId] parameters:@{@"sender":message.sender,@"content":message.text,@"type":message.type} success:^(id data) {
        
        [self sync];
        
        IMSession *imSession = [[IMSession alloc] initWithSession:self.messages.session];
        [self.messages.session.sessions.user.bridge sendMessages:@[@{@"type":@(Y2WSyncTypeMessage), @"sessionId": imSession.ID}] toSession:imSession];

    } failure:failure];
}

- (void)uploadFile:(NSArray *)fileAppends
          progress:(ProgressBlock)progress
           success:(void (^)(NSArray *))success
           failure:(void (^)(NSError *))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
        __block NSMutableArray *fileArray = [NSMutableArray array];
        __block NSError *failureError = nil;
        __block CGFloat totleProgress = 0;
        for (FileAppend *fileAppend in fileAppends) {

            [HttpRequest UPLOADWithURL:[URL attachments] parameters:@{@"fileName":fileAppend.fileName} fileAppend:fileAppend progress:^(CGFloat fractionCompleted) {

                if (totleProgress <= 0.8) {
                    totleProgress = fractionCompleted*0.8;
                }
                else{
                    totleProgress = 0.8+fractionCompleted*0.2;
                }
                progress(totleProgress);
            } success:^(id data) {
                [fileArray addObject:data];
                dispatch_semaphore_signal(dispatchSemaphore);
                
            } failure:^(NSError *error) {
                
                failureError = error;
                dispatch_semaphore_signal(dispatchSemaphore);
            }];
            
            dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
            
            if (failureError) {
                if (failure) failure(failureError);
                return;
            }
        }

        if (success) success(fileArray);
    });
}

@end
