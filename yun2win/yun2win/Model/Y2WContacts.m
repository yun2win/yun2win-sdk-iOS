//
//  Y2WContacts.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WContacts.h"
#import "MulticastDelegate.h"

@interface Y2WContacts ()

@property (nonatomic, retain) MulticastDelegate<Y2WContactsDelegate> *delegates;

@property (nonatomic, strong) NSArray *list;

@end

@implementation Y2WContacts

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.list = [NSMutableArray array];
        self.delegates = [[MulticastDelegate<Y2WContactsDelegate> alloc] init];
        [self update];
        self.remote = [[Y2WContactsRemote alloc] initWithContacts:self];
    }
    return self;
}

- (void)update {
    RLMResults *resluts = [ContactBase objectsInRealm:self.user.realm where:@"isDelete == %d AND type == nil", NO];
   
    NSMutableArray *list = [NSMutableArray array];
    for (ContactBase *base in resluts) {
        Y2WContact *contact = [self getContactWithUID:base.userId];
        if (contact) {
            [contact updateWithBase:base];
            
        }else {
            contact = [[Y2WContact alloc] initWithContacts:self base:base];
        }
        [list addObject:contact];
    }

    self.list = list;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(contactsDidChangeContent:)]) {
            [self.delegates contactsDidChangeContent:self];
        }
    });
}

- (NSArray *)getAllList {
    RLMResults *resluts = [ContactBase objectsInRealm:self.user.realm where:@"isDelete == %d", NO];
    NSMutableArray *list = [NSMutableArray array];
    for (ContactBase *base in resluts) {
        Y2WContact *contact = [self getContactWithUID:base.userId];
        if (contact) {
            [contact updateWithBase:base];
            
        }else {
            contact = [[Y2WContact alloc] initWithContacts:self base:base];
        }
        [list addObject:contact];
    }
    return list;
}

#pragma mark - ———— Y2WContactsDelegateInterface ———— -

- (void)addDelegate:(id<Y2WContactsDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WContactsDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}

- (Y2WContact *)getContactWithUID:(NSString *)uid {
    for (Y2WContact *contact in self.getContacts) {
        if ([contact.userId isEqualToString:uid]) {
            return contact;
        }
    }
    return nil;
}

//获取隐藏的联系人
- (Y2WContact *)getHideContactWithUID:(NSString *)uid{

    NSArray *array =  [[Y2WUsers getInstance].currentUser.contacts getAllList];
    Y2WContact *contact = nil;
    for (Y2WContact *tempContact in array) {
        if ([tempContact.userId isEqualToString:uid]) {
            contact = tempContact;
            break;
        }
    }
    return contact;
}


- (NSArray *)getContacts {
    return self.list.copy;
}

@end





@interface Y2WContactsRemote ()<Y2WSyncManagerDelegate>

@property (nonatomic, weak) Y2WContacts *contacts;

@property (nonatomic, retain) Y2WSyncManager *syncManager;

@end


@implementation Y2WContactsRemote

- (instancetype)initWithContacts:(Y2WContacts *)contacts {
    if (self = [super init]) {
        self.contacts = contacts;
        self.syncManager = [[Y2WSyncManager alloc] initWithDelegate:self
                                                        currentUser:self.contacts.user
                                                                url:[URL contactsWithUID:self.contacts.user.ID]];
    }
    return self;
}


- (void)syncManager:(Y2WSyncManager *)manager didSyncFirstForData:(NSDictionary *)data onError:(NSError *)error {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncForData:(NSDictionary *)data {
    
}

- (void)syncManager:(Y2WSyncManager *)manager didSyncOnceForDatas:(NSArray *)datas {
    RLMArray *contacts = [[RLMArray alloc] initWithObjectClassName:[ContactBase className]];
    for (NSDictionary *data in datas) {
        ContactBase *cotanct = [[ContactBase alloc] initWithValue:data];
        [contacts addObject:cotanct];
    }
    
    RLMRealm *realm = self.contacts.user.realm;
    [realm transactionWithBlock:^{
        [realm addOrUpdateObjectsFromArray:contacts];
    }];
    
    [self.contacts update];
}


- (void)sync:(dispatch_block_t)block {
    [self.syncManager sync:block];
}




- (void)addContact:(Y2WContact *)contact
           success:(void (^)(void))success
           failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = contact.userId;
    if (contact.extend) {
        params[@"extend"] = contact.extend.toJsonString;
    }
    [HttpRequest POSTWithURL:[URL acquireContacts]
                  parameters:params
                     success:^(id data) {

                         [self sync:^{
                             // 同步太快取不着最新数据
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [self.contacts.user.userConversations.remote sync:nil];
                                 [self.contacts.user.sessions getSessionWithTargetId:contact.userId type:@"p2p" success:^(Y2WSession *session) {
                                     IMSession *imSession = [[IMSession alloc] initWithSession:session];
                                     [self.contacts.user.bridge sendMessages:@[@{@"type": @(Y2WSyncTypeUserConversation)},
                                                                               @{@"type": @(Y2WSyncTypeMessage), @"sessionId": imSession.ID},
                                                                               @{@"type": @(Y2WSyncTypeContact)}]
                                                                   toSession:imSession];
                                 } failure:nil];
                             });
                             
                             if (success) success();
                         }];
                         
                     } failure:failure];
}


- (void)deleteContact:(Y2WContact *)contact
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    [HttpRequest DELETEWithURL:[URL aboutContact:contact.ID] parameters:nil success:^(id data) {        
        [self sync:success];
    } failure:failure];
}

- (void)updateContact:(Y2WContact *)contact
           success:(void (^)(void))success
           failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (contact.userId) parameters[@"userId"] = contact.userId;
    if (contact.name) parameters[@"name"] = contact.name;
    if (contact.title) parameters[@"title"] = contact.title.length ? contact.title : @" ";
    if (contact.remark) parameters[@"remark"] = contact.remark;
    if (contact.avatarUrl) parameters[@"avatarUrl"] = contact.avatarUrl;
    
    [HttpRequest PUTWithURL:[URL aboutContact:contact.ID] parameters:parameters success:^(id data) {
        [self sync:success];
    } failure:failure];
}

@end
