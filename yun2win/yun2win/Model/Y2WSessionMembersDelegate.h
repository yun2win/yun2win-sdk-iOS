//
//  Y2WSessionMembersDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WSessionMembers,Y2WSessionMember;
@protocol Y2WSessionMembersDelegate <NSObject>
@optional
///**
// *  会话成员增加的回调
// *
// *  @param sessionMembers 会话成员管理对象
// *  @param sessionMember  添加的会话成员
// */
//- (void)sessionMembers:(Y2WSessionMembers *)sessionMembers
//    onAddSessionMember:(Y2WSessionMember *)sessionMember;
//
//
//
///**
// *  会话成员删除的回调
// *
// *  @param sessionMembers 会话成员管理对象
// *  @param sessionMember  删除的会话成员
// */
//- (void)sessionMembers:(Y2WSessionMembers *)sessionMembers
// onDeleteSessionMember:(Y2WSessionMember *)sessionMember;
//
//
//
///**
// *  会话成员更新的回调
// *
// *  @param sessionMembers 会话成员管理对象
// *  @param sessionMember  更新的会话成员
// */
//- (void)sessionMembers:(Y2WSessionMembers *)sessionMembers
// onUpdateSessionMember:(Y2WSessionMember *)sessionMember;
//
//
//
///**
// *  会话成员将要变化的回调
// *
// *  @param sessionMembers 会话成员管理对象
// */
//- (void)sessionMembersWillChangeContent:(Y2WSessionMembers *)sessionMembers;



/**
 *  会话成员变化完成的回调
 *
 *  @param sessionMembers 会话成员管理对象
 */
- (void)sessionMembersDidChangeContent:(Y2WSessionMembers *)sessionMembers;

@end
