//
//  ConversationViewController.h
//  API
//
//  Created by ShingHo on 16/1/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y2WUserConversation.h"
#import "MessageCellDelegate.h"

@interface ConversationViewController : UIViewController<Y2WMessagesDelegate>

@property (nonatomic, retain) Y2WSession *session;

- (instancetype)initWithSession:(Y2WSession *)session;

@end
