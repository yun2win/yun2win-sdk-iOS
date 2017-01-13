//
//  EmojiManage.h
//  API
//
//  Created by ShingHo on 16/4/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmojiManage : NSObject

@property (nonatomic, strong) NSDictionary *emojisDic;

+ (instancetype)shareEmoji;

- (void)syncEmoji;
@end
