//
//  Y2WContacts.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WContactsDelegate.h"
#import "Y2WContact.h"
@class Y2WCurrentUser;
@class Y2WContactsRemote;

@interface Y2WContacts : NSObject

@property (nonatomic, weak) Y2WCurrentUser *user;

@property (nonatomic, strong) Y2WContactsRemote *remote;



- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;




- (void)addDelegate:(id<Y2WContactsDelegate>)delegate;

- (void)removeDelegate:(id<Y2WContactsDelegate>)delegate;



- (Y2WContact *)getContactWithUID:(NSString *)uid;

//获取隐藏的联系人
- (Y2WContact *)getHideContactWithUID:(NSString *)uid;

- (NSArray *)getContacts;

- (NSArray *)getAllList;

@end





@interface Y2WContactsRemote : NSObject

- (instancetype)initWithContacts:(Y2WContacts *)contacts;

- (void)sync:(dispatch_block_t)block;

/**
 *  添加好友
 * 
 *  @param contact 要添加的联系人对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)addContact:(Y2WContact *)contact
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure;


/**
 *  删除好友
 *
 *  @param contact 要删除的联系人对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)deleteContact:(Y2WContact *)contact
              success:(void(^)(void))success
              failure:(void (^)(NSError *error))failure;



/**
 *  修改好友
 *
 *  @param contact 要修改的联系人对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)updateContact:(Y2WContact *)contact
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;
@end
