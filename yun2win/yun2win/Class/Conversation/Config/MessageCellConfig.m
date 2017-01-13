//
//  MessageCellConfig.m
//  yun2win
//
//  Created by QS on 16/9/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageCellConfig.h"
#import "MessageCell.h"
#import "MessageNotiCell.h"

@implementation MessageCellConfig

+ (Class)cellClassWithMessageBase:(MessageBase *)base {
    if ([base.type isEqualToString:@"text"] ||
        [base.type isEqualToString:@"task"] ||
        [base.type isEqualToString:@"image"] ||
        [base.type isEqualToString:@"location"] ||
        [base.type isEqualToString:@"video"] ||
        [base.type isEqualToString:@"audio"] ||
        [base.type isEqualToString:@"file"]) {
        
        return [MessageCell class];
    }
    return [MessageNotiCell class];
}

- (CGFloat)avatarSize {
    return 32;
}

- (CGFloat)avatarMargin {
    return 10;
}

- (CGFloat)timeStampHeight {
    return 30;
}

- (CGFloat)textFontSize {
    return 15;
}

@end
