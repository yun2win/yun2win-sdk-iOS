//
//  Y2WUserConversations.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WUserConversations.h"
#import "Y2WCurrentUser.h"
#import "MulticastDelegate.h"
#import "Y2WSyncManager.h"

@interface Y2WUserConversations ()

@property (nonatomic, retain) MulticastDelegate<Y2WUserConversationsDelegate> *delegates; //多路委托对象

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) NSArray *allList;

@property (nonatomic, retain) RLMNotificationToken *token;

@end

@implementation Y2WUserConversations

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        [self update];
        [self setup];
        self.delegates =  [[MulticastDelegate<Y2WUserConversationsDelegate> alloc] init];
        self.remote = [[Y2WUserConversationsRemote alloc] initWithUserConversations:self];
    }
    return self;
}

- (void)setup {
    RLMResults *results = [[UserConversationBase objectsInRealm:self.user.realm where:@"isDelete == %d AND hidden == %d", NO, NO]
                           sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"top" ascending:NO],
                                                           [RLMSortDescriptor sortDescriptorWithProperty:@"updatedAt" ascending:NO]]];
    
    NSMutableArray *list = [NSMutableArray array];
    for (UserConversationBase *base in results) {
        [list addObject:[[Y2WUserConversation alloc] initWithUserConversations:self base:base]];
    }
    self.list = list;
    
    results = [[UserConversationBase objectsInRealm:self.user.realm where:@"isDelete == %d AND hidden == %d", NO, NO]
                           sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"top" ascending:NO],
                                                           [RLMSortDescriptor sortDescriptorWithProperty:@"updatedAt" ascending:NO]]];

    __weak typeof(self) weakSelf = self;
    self.token = [results addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (!change) {
            return;
        }
        
        NSMutableArray *list = [NSMutableArray array];
        for (UserConversationBase *base in results) {
            Y2WUserConversation *userConversation = [self getUserConversationById:base.ID];
            if (userConversation) {
                [userConversation updateWithBase:base];
                
            }else {
                userConversation = [[Y2WUserConversation alloc] initWithUserConversations:self base:base];
            }
            [list addObject:userConversation];
        }
        weakSelf.list = list;
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([weakSelf.delegates respondsToSelector:@selector(userConversationsWillChangeContent:)]) {
                [weakSelf.delegates userConversationsWillChangeContent:weakSelf];
            }
            
            if ([weakSelf.delegates respondsToSelector:@selector(userConversations:didDeleteIndexPaths:)]) {
                [weakSelf.delegates userConversations:weakSelf didDeleteIndexPaths:[change deletionsInSection:0]];
            }
            
            if ([weakSelf.delegates respondsToSelector:@selector(userConversations:didInsertIndexPaths:)]) {
                [weakSelf.delegates userConversations:weakSelf didInsertIndexPaths:[change insertionsInSection:0]];
            }
            
            if ([weakSelf.delegates respondsToSelector:@selector(userConversations:didReloadIndexPaths:)]) {
                [weakSelf.delegates userConversations:weakSelf didReloadIndexPaths:[change modificationsInSection:0]];
            }
            
            if ([weakSelf.delegates respondsToSelector:@selector(userConversationsDidChangeContent:)]) {
                [weakSelf.delegates userConversationsDidChangeContent:weakSelf];
            }
        });
    }];
}

- (void)update {
//    RLMResults *results = [[UserConversationBase objectsInRealm:self.user.realm where:@"isDelete == %d AND hidden == %d", NO, NO]
//                           sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"top" ascending:NO],
//                                                           [RLMSortDescriptor sortDescriptorWithProperty:@"updatedAt" ascending:NO]]];
//    
//    NSMutableArray *list = [NSMutableArray array];
//    for (UserConversationBase *base in results) {
//        [list addObject:[[Y2WUserConversation alloc] initWithUserConversations:self base:base]];
//    }
//    self.list = list;
    
    NSMutableArray *allList = [NSMutableArray array];
    RLMResults *allResults = [UserConversationBase allObjectsInRealm:self.user.realm];
    for (UserConversationBase *base in allResults) {
        [allList addObject:[[Y2WUserConversation alloc] initWithUserConversations:self base:base]];
    }
    self.allList = allList;
}

//- (void)update {
//    RLMResults *resluts = [UserConversationBase objectsInRealm:self.user.realm where:@"isDelete == %d", NO];
//    resluts = [resluts sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"top" ascending:NO],
//                                                       [RLMSortDescriptor sortDescriptorWithProperty:@"updatedAt" ascending:NO]]];
//    
//    NSMutableArray *list = [NSMutableArray array];
//    NSMutableArray *deletes = [NSMutableArray array];
//    NSMutableArray *inserts = [NSMutableArray array];
//    NSMutableArray *reloads = [NSMutableArray array];
//
////    for (UserConversationBase *base in resluts) {
////        Y2WUserConversation *userConversation = [self getUserConversationById:base.ID];
////        if (userConversation) {
////            [userConversation updateWithBase:base];
////            [reloads addObject:[NSIndexPath indexPathForRow:list.count inSection:0]];
////            
////        }else {
////            userConversation = [[Y2WUserConversation alloc] initWithUserConversations:self base:base];
////            [inserts addObject:[NSIndexPath indexPathForRow:list.count inSection:0]];
////        }
////        [list addObject:userConversation];
////    }
//    
//    
//    
//    
//    for (UserConversationBase *base in resluts) {
//        Y2WUserConversation *userConversation = [self getUserConversationById:base.ID];
//        if (userConversation) {
//            [userConversation updateWithBase:base];
//            
//        }else {
//            userConversation = [[Y2WUserConversation alloc] initWithUserConversations:self base:base];
//            [inserts addObject:[NSIndexPath indexPathForRow:list.count inSection:0]];
//        }
//        [list addObject:userConversation];
//    }
//    
//    for (Y2WUserConversation *userConversation in self.list) {
//        NSInteger index = [list indexOfObject:userConversation];
//        if (index == NSNotFound) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//            [deletes addObject:indexPath];
//      
//        }else {
//            [reloads addObject:[NSIndexPath indexPathForRow:[self.list indexOfObject:userConversation] inSection:0]];
//        }
//    }
//    
//    
//    NSLog(@"\n%@\n%@\n%@",deletes,inserts,reloads);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.list = list;
//        
//        if ([self.delegates respondsToSelector:@selector(userConversationsWillChangeContent:)]) {
//            [self.delegates userConversationsWillChangeContent:self];
//        }
//        
//        if ([self.delegates respondsToSelector:@selector(userConversations:didDeleteIndexPaths:)]) {
//            [self.delegates userConversations:self didDeleteIndexPaths:deletes];
//        }
//        
//        if ([self.delegates respondsToSelector:@selector(userConversations:didInsertIndexPaths:)]) {
//            [self.delegates userConversations:self didInsertIndexPaths:inserts];
//        }
//        
//        if ([self.delegates respondsToSelector:@selector(userConversations:didReloadIndexPaths:)]) {
//            [self.delegates userConversations:self didReloadIndexPaths:reloads];
//        }
//        
//        if ([self.delegates respondsToSelector:@selector(userConversationsDidChangeContent:)]) {
//            [self.delegates userConversationsDidChangeContent:self];
//        }
//    });
//}




#pragma mark - ———— Y2WUserConversationsDelegateInterface ———— -

- (void)addDelegate:(id<Y2WUserConversationsDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WUserConversationsDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}




- (Y2WUserConversation *)getUserConversationById:(NSString *)userConversationId {
    for (Y2WUserConversation *userConversation in self.allList.copy) {
        if ([userConversation.ID isEqualToString:userConversationId]) {
            return userConversation;
        }
    }
    return nil;
}

- (Y2WUserConversation *)getUserConversationWithTargetId:(NSString *)targetId type:(NSString *)type {
    for (Y2WUserConversation *userConversation in self.allList.copy) {
        if ([userConversation.targetId isEqualToString:targetId] && [userConversation.type isEqualToString:type]) {
            return userConversation;
        }
    }
    return nil;
}

- (NSArray *)getUserConversations {
    return self.list.copy;
}

@end







@interface Y2WUserConversationsRemote ()<Y2WSyncManagerDelegate>

@property (nonatomic, weak) Y2WUserConversations *userConversations;

@property (nonatomic, retain) Y2WSyncManager *syncManager; // 同步管理器

@end


@implementation Y2WUserConversationsRemote

- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations {
    if (self = [super init]) {
        self.userConversations = userConversations;

        self.syncManager = [[Y2WSyncManager alloc] initWithDelegate:self
                                                        currentUser:self.userConversations.user
                                                                url:[URL userConversationsWithUID:self.userConversations.user.ID]];
    }
    return self;
}


- (void)syncManager:(Y2WSyncManager *)manager didSyncFirstForData:(NSDictionary *)data onError:(NSError *)error {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncForData:(NSDictionary *)data {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncOnceForDatas:(NSArray *)datas {

    RLMRealm *realm = self.userConversations.user.realm;
    [realm transactionWithBlock:^{
        for (NSDictionary *data in datas) {
            [UserConversationBase createOrUpdateInRealm:realm withValue:data];
        }
    }];
    [self.userConversations update];
}


- (void)sync:(dispatch_block_t)block {
    [self.syncManager sync:block];
}




- (void)deleteUserConversation:(Y2WUserConversation *)userConversation
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *))failure {
    
    [HttpRequest DELETEWithURL:[URL singleUserConversation:userConversation.ID] parameters:nil success:^(id data) {
        [self sync:^{
            [self.userConversations.user.bridge sendOtherDeviceMessages:nil];
            if (success) success();
        }];
    } failure:failure];
}

- (void)updateUserConversation:(Y2WUserConversation *)userConversation
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = [userConversation toParameters];
    [HttpRequest PUTWithURL:[URL singleUserConversation:userConversation.ID] parameters:parameters success:^(id data) {
        [self syncManager:self.syncManager didSyncOnceForDatas:@[data]];
        [self sync:^{
            [self.userConversations.user.bridge sendOtherDeviceMessages:nil];
            if (success) success();
        }];
    } failure:failure];
}

@end
