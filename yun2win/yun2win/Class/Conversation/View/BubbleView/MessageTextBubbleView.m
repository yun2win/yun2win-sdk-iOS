//
//  MessageTextBubbleView.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageTextBubbleView.h"

@interface MessageTextBubbleView ()

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, retain) NSMutableDictionary *bubbleImages;

@end


@implementation MessageTextBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create {
    MessageTextBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.titleLabel.numberOfLines = 0;
    return view;
}


- (void)refreshData:(MessageModel *)data {
    _model = data;
    
    [self setTitleEdgeInsets:_model.contentViewInsets];
    [self.titleLabel setFont:[UIFont systemFontOfSize:_model.cellConfig.textFontSize]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableAttributedString *string = [data.message.content[@"text"] stringForAttributedString];
        if ([_model.message.type isEqualToString:@"task"]) {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor y2w_blueColor] range:NSMakeRange(0, string.length)];
        }
        else if (!_model.isMe && _model.message.byTheAt) {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor y2w_atColor] range:NSMakeRange(0, string.length)];
        }
        else {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setAttributedTitle:string forState:UIControlStateNormal];
        });
    });

    
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateNormal outgoing:data.isMe] forState:UIControlStateNormal];
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateHighlighted outgoing:data.isMe] forState:UIControlStateHighlighted];
    [self setNeedsLayout];
}



- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{
    if (!_bubbleImages) _bubbleImages = [NSMutableDictionary dictionary];
    
    if (outgoing) {
        if (state == UIControlStateNormal)
        {
            UIImage *image = _bubbleImages[@"本方气泡-默认"];
            if (!image) {
                
                image = [[UIImage y2w_imageNamed:@"本方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted)
        {
            UIImage *image = _bubbleImages[@"本方气泡-按下"];
            if (!image) {
                
                image = [[UIImage y2w_imageNamed:@"本方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-按下"] = image;
            }
            return image;
        }
        
    }else {
        if (state == UIControlStateNormal) {
            
            UIImage *image = _bubbleImages[@"对方气泡-默认"];
            if (!image) {
                
                image = [[UIImage y2w_imageNamed:@"对方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted) {
            
            UIImage *image = _bubbleImages[@"对方气泡-按下"];
            if (!image) {
                
                image = [[UIImage y2w_imageNamed:@"对方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-按下"] = image;
            }
            return image;
        }
    }
    return nil;
}


@end
