//
//  MessageAudioBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageAudioBubbleView.h"
#import "Y2WAudioMessage.h"

@interface MessageAudioBubbleView()

@property (nonatomic ,strong) MessageModel *model;

@property (nonatomic, strong) UIImageView *animationView;

@end

@implementation MessageAudioBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create {
    MessageAudioBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    [view.imageView setAnimationDuration:0.4];

    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    if (_model.isMe) {
        self.backgroundColor = [UIColor colorWithHexString:@"6ce5dc"];
        [self setImage:[UIImage y2w_imageNamed:@"voice_white_play_0"] forState:UIControlStateNormal];
        [self.imageView setAnimationImages:@[[UIImage y2w_imageNamed:@"voice_white_play_0"],
                                             [UIImage y2w_imageNamed:@"voice_white_play_1"],
                                             [UIImage y2w_imageNamed:@"voice_white_play_2"],
                                             [UIImage y2w_imageNamed:@"voice_white_play_3"],
                                             [UIImage y2w_imageNamed:@"voice_white_play_4"]]];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self setImage:[UIImage y2w_imageNamed:@"voice_green_play_0"] forState:UIControlStateNormal];
        [self.imageView setAnimationImages:@[[UIImage y2w_imageNamed:@"voice_green_play_0"],
                                             [UIImage y2w_imageNamed:@"voice_green_play_1"],
                                             [UIImage y2w_imageNamed:@"voice_green_play_2"],
                                             [UIImage y2w_imageNamed:@"voice_green_play_3"],
                                             [UIImage y2w_imageNamed:@"voice_green_play_4"]]];
    }
}


- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    
    if (_animating && !self.imageView.isAnimating) {
        return [self.imageView startAnimating];
    }
    
    if (!_animating && self.imageView.isAnimating) {
        return [self.imageView stopAnimating];
    }
}

@end
