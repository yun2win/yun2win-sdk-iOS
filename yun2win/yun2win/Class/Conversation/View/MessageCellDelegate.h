//
//  MessageCellDelegate.h
//  API
//
//  Created by ShingHo on 16/4/5.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageCell,Y2WBaseMessage;
@protocol MessageCellDelegate <NSObject>

@optional

- (void)onTapAvatar:(NSString *)userId;

- (void)onLongPressCell:(Y2WBaseMessage *)message inView:(UIView *)view;

- (void)messageCell:(MessageCell *)cell didClickRetryWithMessage:(Y2WBaseMessage *)message;

- (void)messageCell:(MessageCell *)cell didClickBubbleView:(UIView *)view message:(Y2WBaseMessage *)message;

- (void)messageCell:(MessageCell *)cell didClickReadedWithMessage:(Y2WBaseMessage *)message;

@end
