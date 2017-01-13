//
//  MessageCellConfig.h
//  yun2win
//
//  Created by QS on 16/9/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCellConfig : NSObject

+ (Class)cellClassWithMessageBase:(MessageBase *)base;

- (CGFloat)avatarSize;

- (CGFloat)avatarMargin;

- (CGFloat)timeStampHeight;

- (CGFloat)textFontSize;

@end
