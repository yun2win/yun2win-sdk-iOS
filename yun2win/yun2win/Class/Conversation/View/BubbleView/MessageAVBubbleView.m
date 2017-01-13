//
//  MessageAVBubbleView.m
//  yun2win
//
//  Created by QS on 16/9/28.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageAVBubbleView.h"

@interface MessageAVBubbleView ()

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, retain) NSMutableDictionary *bubbleImages;

@end


@implementation MessageAVBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create {
    MessageAVBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    
    view.icon = [[UIImageView alloc]init];
    view.icon.left = 10;
    view.icon.top = 10;
    view.icon.height = 50;
    view.icon.width = 50;
    [view addSubview:view.icon];
    
    view.textLabel = [[UILabel alloc]init];
    view.textLabel.left = 70;
    view.textLabel.top = 10;
    view.textLabel.height = 40;
    view.textLabel.width = 170;
    view.textLabel.numberOfLines = 3;
    view.textLabel.font = [UIFont boldSystemFontOfSize:14];
    view.textLabel.textColor = [UIColor colorWithHexString:@"353535"];
    [view addSubview:view.textLabel];
    
    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WFileMessage *message = (Y2WFileMessage *)temp_message;
    
    if (_model.isMe) {
        self.backgroundColor = [UIColor colorWithHexString:@"6ce5dc"];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    
    self.icon.image = [UIImage y2w_imageNamed:@"气泡_视频通话"];
    self.textLabel.text = message.text;
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
