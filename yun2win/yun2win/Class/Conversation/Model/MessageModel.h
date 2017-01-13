//
//  MessageModel.h
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

typedef NS_ENUM(NSInteger, MessageModelStatus) {
    MessageModelStatusNormal = 0,
    MessageModelStatusSending,
    MessageModelStatusSendFailed
};



#import <Foundation/Foundation.h>
#import "MessageCellConfig.h"

@interface MessageModel : NSObject

@property (nonatomic, retain) MessageCellConfig *cellConfig;

@property (nonatomic, retain) Y2WSessionMember *member;


/**
 *  消息数据
 */
@property (nonatomic, strong) Y2WBaseMessage *message;

@property (nonatomic, copy) NSString *bubbleViewClassName;


@property (nonatomic, readonly) BOOL isMe;

@property (nonatomic, readonly) BOOL shouldShowTimeStamp;

@property (nonatomic, readonly) BOOL isShowReaded;

@property (nonatomic, assign) MessageModelStatus status;

/**
 *  单元格高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGRect timeStampFrame;

@property (nonatomic, assign) CGRect avatarFrame;

@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, readonly) UIEdgeInsets  contentViewInsets;





- (instancetype)initWithMessage:(Y2WBaseMessage *)message;

- (void)cleanCache;

- (void)calculateContent:(CGFloat)width;

@end
