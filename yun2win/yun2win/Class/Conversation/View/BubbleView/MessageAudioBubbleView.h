//
//  MessageAudioBubbleView.h
//  API
//
//  Created by ShingHo on 16/4/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBubbleInterface.h"

@interface MessageAudioBubbleView : UIButton<MessageBubbleInterface>

@property (nonatomic, assign) BOOL animating;

@end
