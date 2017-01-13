//
//  Y2WUserConversationsDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WUserConversations,Y2WUserConversation;
@protocol Y2WUserConversationsDelegate <NSObject>

@optional

/**
 *  会话删除的回调
 *
 *  @param userConversations 用户会话的管理对象
 *  @param userConversation  删除的用户会话对象
 */
- (void)userConversations:(Y2WUserConversations *)userConversations
      didDeleteIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;


/**
 *  会话增加的回调
 *
 *  @param userConversations 用户会话的管理对象
 *  @param userConversation  增加的用户会话对象
 */
- (void)userConversations:(Y2WUserConversations *)userConversations
      didInsertIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;


/**
 *  会话更新的回调
 *
 *  @param userConversations 用户会话的管理对象
 *  @param userConversation  更新的用户会话对象
 */
- (void)userConversations:(Y2WUserConversations *)userConversations
      didReloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;


/**
 *  用户会话将要变化的回调
 *
 *  @param userConversations 用户会话的管理对象
 */
- (void)userConversationsWillChangeContent:(Y2WUserConversations *)userConversations;


/**
 *  用户会话变化完成的回调
 *
 *  @param userConversations 用户会话的管理对象
 */
- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations;

@end
