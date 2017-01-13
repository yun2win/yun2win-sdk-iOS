//
//  Y2WSyncManager.h
//  API
//
//  Created by QS on 16/8/25.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WSyncManager,Y2WCurrentUser;
@protocol Y2WSyncManagerDelegate <NSObject>

@optional

/**
 *  初始同步完成
 *
 *  @param manager 同步管理器
 *  @param error   如果出错返回错误
 */
- (void)syncManager:(Y2WSyncManager *)manager didSyncFirstForData:(NSDictionary *)data onError:(NSError *)error;

/**
 *  每次同步完全完成
 *
 *  @param manager 同步管理器
 */
- (void)syncManager:(Y2WSyncManager *)manager didSyncForData:(NSDictionary *)data;

/**
 *  每次同步后调用
 *
 *  @param manager 同步管理器
 *  @param datas   本次同步返回的数据
 */
- (void)syncManager:(Y2WSyncManager *)manager didSyncOnceForDatas:(NSArray *)datas;

@end

@interface Y2WSyncManager : NSObject

@property (nonatomic, assign) BOOL isFinishedFirstSync;

- (instancetype)initWithDelegate:(id<Y2WSyncManagerDelegate>)delegate currentUser:(Y2WCurrentUser *)user url:(NSString *)url;

- (void)sync;
- (void)sync:(dispatch_block_t)block;

@end