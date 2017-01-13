//
//  Y2WAudioPlayer.h
//  yun2win
//
//  Created by QS on 16/10/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WAudioPlayer;

@protocol Y2WAudioPlayerDelegate <NSObject>

- (void)audioPlayerWillPlay:(Y2WAudioPlayer *)player;

- (void)audioPlayerDidStop:(Y2WAudioPlayer *)player;

- (void)audioPlayer:(Y2WAudioPlayer *)player didFailWithError:(NSError *)error;

@end



@interface Y2WAudioPlayer : NSObject

- (instancetype)initWithDelegate:(id<Y2WAudioPlayerDelegate>)delegate;

- (void)playWithAttachmentId:(NSString *)attachmentId;

- (void)playWithFile:(NSString *)path;

- (void)stop;

- (NSTimeInterval)audioDuration;

@end
