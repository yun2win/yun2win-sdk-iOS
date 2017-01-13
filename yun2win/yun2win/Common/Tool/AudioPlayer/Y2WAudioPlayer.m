//
//  Y2WAudioPlayer.m
//  yun2win
//
//  Created by QS on 16/10/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface Y2WAudioPlayer ()<AVAudioPlayerDelegate,Y2WAttachmentDelegate>

@property (nonatomic, weak) id<Y2WAudioPlayerDelegate>delegate;

@property (nonatomic, retain) AVAudioPlayer *player;

@property (nonatomic, assign) BOOL playing;

@end


@implementation Y2WAudioPlayer

- (instancetype)initWithDelegate:(id<Y2WAudioPlayerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)playWithAttachmentId:(NSString *)attachmentId {
    self.playing = YES;
    Y2WAttachment *attachment = [[Y2WUsers getInstance].getCurrentUser.attachments getAttachmentById:attachmentId];
    if (attachment.isDownloaded) {
        return [self playWithFile:attachment.path];
    }
    if (attachment.task) {
        [attachment.task cancel];
    }
    [[Y2WUsers getInstance].getCurrentUser.attachments getAttachmentById:attachmentId success:^(Y2WAttachment *attachment) {
        [attachment addDelegate:self];
        [attachment download];
        
    } failure:^(NSError *error) {
        [self stop];
        if ([self.delegate respondsToSelector:@selector(audioPlayer:didFailWithError:)]) {
            [self.delegate audioPlayer:self didFailWithError:error];
        }
    }];
}

- (void)playWithFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self playWithData:data];
}

- (void)playWithData:(NSData *)data {
    NSError *error;
    self.player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    self.player.volume = 1.0f;
    self.player.delegate = self;
    
    if (error) {
        [self stop];
        if ([self.delegate respondsToSelector:@selector(audioPlayer:didFailWithError:)]) {
            [self.delegate audioPlayer:self didFailWithError:error];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
            [self.player play];
        });
    }
}

- (void)stop {
    if (self.player && self.player.isPlaying) {
        self.player.delegate = nil;
        [self.player stop];
        self.player = nil;
    }
    self.playing = NO;
}

- (NSTimeInterval)audioDuration {
    return self.player.duration;
}



- (void)setPlaying:(BOOL)playing {
    if (_playing == playing) {
        return;
    }
    _playing = playing;
    
    if (_playing) {
        if ([self.delegate respondsToSelector:@selector(audioPlayerWillPlay:)]) {
            [self.delegate audioPlayerWillPlay:self];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(audioPlayerDidStop:)]) {
            [self.delegate audioPlayerDidStop:self];
        }
    }
}




#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stop];
}



#pragma mark - Y2WAttachmentDelegate

- (void)attachmentDidDownload:(Y2WAttachment *)attachment {
    [self playWithAttachmentId:attachment.ID];
}

@end
