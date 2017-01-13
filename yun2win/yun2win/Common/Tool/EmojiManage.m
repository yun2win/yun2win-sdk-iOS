//
//  EmojiManage.m
//  API
//
//  Created by ShingHo on 16/4/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "EmojiManage.h"

@interface EmojiManage()

@property (nonatomic , copy) NSString *timeStamp;

@property (nonatomic, strong) dispatch_queue_t dispath_queue_background;

@property (nonatomic, strong) NSMutableArray *emojiArr;

@end

@implementation EmojiManage

+ (instancetype)shareEmoji
{
    static dispatch_once_t once;
    static EmojiManage *manager;
    dispatch_once(&once, ^{
        manager = [[EmojiManage alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.dispath_queue_background = dispatch_queue_create("dispath_queue_background", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)syncEmoji
{
    [HttpRequest GETWithURL:[URL emojis] timeStamp:self.timeStamp parameters:@{@"limit":@(100)} success:^(id data) {
        
        dispatch_async(self.dispath_queue_background, ^{
            NSArray *tempArr = data[@"entries"];
            NSInteger totalCount = [data[@"total_count"] integerValue];
            NSInteger surplusCount = totalCount - tempArr.count;
            
            [self downloadEmoji:tempArr success:^(NSArray *emojiArray) {
                [self createPlist:emojiArray];
            } failure:^(NSError *error) {
            }];
            if (surplusCount > 100) {
                self.timeStamp = tempArr.lastObject[@"updatedAt"];
                [self syncEmoji];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

- (NSDictionary *)emojisDic
{
    if(!_emojisDic)
    {
        NSFileManager * defaultManager = [NSFileManager defaultManager];
        NSString *fileSavePath;
        if (defaultManager) {
            NSURL * documentPath = [[defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
            fileSavePath = [documentPath.path stringByAppendingPathComponent:@"Emoji.plist"];
        }
        _emojisDic = [[NSDictionary dictionaryWithContentsOfFile:fileSavePath] copy];
    }
    return _emojisDic;
}

#pragma mark - 私有方法

- (void)downloadEmoji:(NSArray *)emojiArr success:(void(^)(NSArray *emojiArray))success failure:(void(^)(NSError *error))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
        __block NSMutableArray *emojiArray = [NSMutableArray array];
        __block NSError *failureError = nil;
        for (NSMutableDictionary *dict in emojiArr) {
            NSString *url = [[URL domain] stringByAppendingFormat:@"%@?access_token=%@",dict[@"url"],[[Y2WUsers getInstance].getCurrentUser token]];
            [HttpRequest DOWNLOADWithURL:url parameters:nil progress:^(CGFloat fractionCompleted) {
                
            } success:^(NSURL *path) {
                [[NSFileManager defaultManager] moveItemAtPath:path.path toPath:[[NSString emojiPath] stringByAppendingPathComponent:path.lastPathComponent] error:nil];
                [dict setValue:path.lastPathComponent forKey:@"path"];
                
                [emojiArray addObject:dict];
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
        
        if (success) success(emojiArray);
    });
}

//        [self createPlist:tempArr];

- (void)createPlist:(NSArray *)array
{
//    NSString * fileSavePath;
//    if (![[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]) {
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSURL * documentPath = [[defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSString *fileSavePath = [documentPath.path stringByAppendingPathComponent:@"Emoji.plist"];
//    }
//    fileSavePath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSDictionary *tempDic = @{@"People":array};
   [tempDic writeToFile:fileSavePath atomically:YES];
}

#pragma mark - ———— getter ———— -

- (NSString *)timeStamp {
    if (!_timeStamp) {
        _timeStamp = _timeStamp ?: @"1990-01-01T00:00:00";
    }
    return _timeStamp;
}

- (NSMutableArray *)emojiArr
{
    if (!_emojiArr) {
        _emojiArr = [NSMutableArray array];
        
    }
    return _emojiArr;
}

@end
