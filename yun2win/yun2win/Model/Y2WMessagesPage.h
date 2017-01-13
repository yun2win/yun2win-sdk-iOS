//
//  Y2WMessagesPage.h
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "MessageBase.h"

@class Y2WMessagesPage;
@protocol Y2WMessagesPageDelegate <NSObject>

- (void)messagePage:(Y2WMessagesPage *)page
    didLoadMessages:(RLMResults<MessageBase> *)messages;

- (void)messagePage:(Y2WMessagesPage *)page
didLoadLastMessages:(RLMArray<MessageBase> *)messages;

- (void)messagePage:(Y2WMessagesPage *)page
didDeleteIndexPaths:(NSArray<NSIndexPath *> *)deleteIndexPaths
 didInsetIndexPaths:(NSArray<NSIndexPath *> *)insetIndexPaths
didReloadIndexPaths:(NSArray<NSIndexPath *> *)reloadIndexPaths;

@end



@interface Y2WMessagesPage : NSObject

@property (nonatomic, assign) id<Y2WMessagesPageDelegate>delegate;

@property (nonatomic, retain) RLMResults<MessageBase> *messages;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger offset;


- (instancetype)initWithSessionId:(NSString *)sessionId;

- (void)start;

- (void)loadLastMessage;

@end
