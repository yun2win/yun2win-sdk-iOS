//
//  Y2WSyncManager.m
//  API
//
//  Created by QS on 16/8/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSyncManager.h"

@interface Y2WSyncManager ()

@property (nonatomic, weak) id<Y2WSyncManagerDelegate>delegate;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) BOOL hasTask;

@property (nonatomic, assign) BOOL isWorking;

//@property (nonatomic, assign) BOOL retrytimes; // 最大循环次数

@property (nonatomic, retain) dispatch_queue_t queue;

@property (nonatomic, retain) NSMutableArray *blocks;

@property (nonatomic, retain) NSTimer *timer;


@end


@implementation Y2WSyncManager

- (instancetype)initWithDelegate:(id<Y2WSyncManagerDelegate>)delegate currentUser:(Y2WCurrentUser *)user url:(NSString *)url {
    if (self = [super init]) {
        self.delegate = delegate;
        self.uid = user.ID;
        self.url = url.copy;
        self.blocks = [NSMutableArray array];
        
        NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
        self.time = time ?: @"1990-01-01T00:00:00";
        self.queue = dispatch_queue_create([[self.time stringByAppendingString:[@"Y2WSyncManager:" stringByAppendingString:url]] UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)sync {
    [self sync:nil];
}

- (void)sync:(dispatch_block_t)block {
    [self.timer invalidate];
    self.timer = nil;
    
    if (block) {
        [self.blocks addObject:block];
    }
    
    // 如果已经有新任务则不继续操作
    if (self.hasTask) {
        return;
    }
    
    // 如果正在同步中则添加新任务后返回不再继续操作
    if (self.isWorking) {
        self.hasTask = YES;
        return;
    }
    
    // 开始同步
    self.isWorking = YES;
    
    [HttpRequest GETWithURL:self.url
                  timeStamp:self.time
                 parameters:@{@"limit":@"200"}
                    success:^(NSDictionary *data) {
                        [self excute:^{
                            NSArray *entries = [data[@"entries"] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt"
                                                                                                                             ascending:YES]]];
                            NSUInteger count = [data[@"total_count"] integerValue] - entries.count;
                            
                            if (entries.count) {
                                if ([self.delegate respondsToSelector:@selector(syncManager:didSyncOnceForDatas:)]) {
                                    [self.delegate syncManager:self didSyncOnceForDatas:entries];
                                }else {
                                    return;
                                }
                                self.time = entries.lastObject[@"updatedAt"];
                            }
                            
                            
                            BOOL againSync = count || self.hasTask;
                            self.hasTask = NO;
                            self.isWorking = NO;
                            
                            // 如果需要就再同步一次消息
                            if (againSync) {
                                [self sync:nil];
                                
                            }else {
                                // 同步完成，如果是第一次则回调
                                if (!self.isFinishedFirstSync) {
                                    self.isFinishedFirstSync = YES;
                                    
                                    if ([self.delegate respondsToSelector:@selector(syncManager:didSyncFirstForData:onError:)]) {
                                        [self.delegate syncManager:self didSyncFirstForData:data onError:nil];
                                    }
                                }
                                if ([self.delegate respondsToSelector:@selector(syncManager:didSyncForData:)]) {
                                    [self.delegate syncManager:self didSyncForData:data];
                                }
                                [self syncFinished];
                            }
                        }];
                        
                    } failure:^(NSError *error) {
                        self.hasTask = NO;
                        self.isWorking = NO;
                        
                        if (!self.isFinishedFirstSync) {
                            self.isFinishedFirstSync = YES;
                            if ([self.delegate respondsToSelector:@selector(syncManager:didSyncFirstForData:onError:)]) {
                                [self.delegate syncManager:self didSyncFirstForData:nil onError:error];
                            }
                        }
                        [self syncFinished];
                        
                        // 没有权限则不再处理
                        if (error.code == NSURLErrorBadServerResponse) {
                            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                            if (response.statusCode == 403) {
                                return;
                            }
                        }
                        
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sync) userInfo:nil repeats:NO];
                        NSLog(@"\n%s\n%@\n%@\n%@",__FUNCTION__,self.url,self.time, error.message);
                    }];
}

- (void)excute:(dispatch_block_t)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), self.queue, block);
}







- (void)syncFinished {
    NSArray *blocks = self.blocks.copy;
    [self.blocks removeAllObjects];
    for (dispatch_block_t block in blocks) {
        if (block) {
            block();
        }
    }
}






- (void)setTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:self.key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _time = time;
}


- (NSString *)key {
    return [[self.uid stringByAppendingString:self.url] MD5Hash];
}

@end
