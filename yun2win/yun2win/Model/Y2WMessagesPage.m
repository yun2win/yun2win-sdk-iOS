//
//  Y2WMessagesPage.m
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WMessagesPage.h"
#import <Realm/Realm.h>

@interface Y2WMessagesPage ()

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, retain) RLMNotificationToken *noti;

@end


@implementation Y2WMessagesPage

- (void)dealloc {
    [self.noti stop];
}

- (instancetype)initWithSessionId:(NSString *)sessionId {
    
    if (self = [super init]) {
        self.sessionId = sessionId;
    }
    return self;
}


- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        RLMResults *results = [[MessageBase objectsInRealm:[Y2WUsers getInstance].getCurrentUser.realm where:@"sessionId == %@",self.sessionId] sortedResultsUsingProperty:@"createdAt" ascending:YES];
        
        __weak typeof(self) weakSelf = self;
        self.noti = [results addNotificationBlock:^(RLMResults<MessageBase> * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {

            if (!change) {
                weakSelf.messages = results;
                weakSelf.count = MIN(1000000, results.count);
                
                if ([weakSelf.delegate respondsToSelector:@selector(messagePage:didLoadMessages:)]) {
                    [weakSelf.delegate messagePage:weakSelf
                                   didLoadMessages:weakSelf.messages];
                }
                
            }else if ([weakSelf.delegate respondsToSelector:@selector(messagePage:didDeleteIndexPaths:didInsetIndexPaths:didReloadIndexPaths:)]) {
                
                [weakSelf updateCountWithChange:change];
                NSArray *deletes = [weakSelf indexPathsFromArray:[change deletionsInSection:0]];
                NSArray *inserts = [weakSelf indexPathsFromArray:[change insertionsInSection:0]];
                NSArray *changes = [weakSelf indexPathsFromArray:[change modificationsInSection:0]];
                [weakSelf.delegate messagePage:weakSelf
                           didDeleteIndexPaths:deletes
                            didInsetIndexPaths:inserts
                           didReloadIndexPaths:changes];
            }
        }];
    });
}

- (void)loadLastMessage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger addCount = MIN(1000, self.messages.count - self.count);
        self.count += addCount;
        NSInteger offset = self.offset;
        
        RLMArray<MessageBase> *messages = [[RLMArray<MessageBase> alloc] initWithObjectClassName:[MessageBase className]];
        for (NSInteger i = offset; i < (offset + addCount); i++) {
            [messages addObject:self.messages[i]];
        }
        if ([self.delegate respondsToSelector:@selector(messagePage:didLoadLastMessages:)]) {
            [self.delegate messagePage:self didLoadLastMessages:messages];
        }
    });
}






- (NSInteger)offset {
    return self.messages.count - self.count;
}

- (void)updateCountWithChange:(RLMCollectionChange *)change {
    NSArray *deletes = [self indexPathsFromArray:[change deletionsInSection:0]];
    NSArray *inserts = [self indexPathsFromArray:[change insertionsInSection:0]];
    
    self.count = self.count + inserts.count - deletes.count;
}

- (NSArray *)indexPathsFromArray:(NSArray *)array {
    if (!array) {
        return nil;
    }
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSIndexPath *indexPath in array) {
        NSInteger row = indexPath.row - self.offset;
        if (row >= 0) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        }
    }
    return indexPaths;
}

@end
