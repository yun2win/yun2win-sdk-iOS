//
//  MessageVideoBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageVideoBubbleView.h"
#import "Y2WVideoMessage.h"

@interface MessageVideoBubbleView ()<Y2WAttachmentDelegate>

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, retain) Y2WVideoMessage *message;

@property (nonatomic, strong) UIImageView *playImg;

@end

@implementation MessageVideoBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create {
    MessageVideoBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    
    view.playImg = [[UIImageView alloc] initWithImage:[UIImage y2w_imageNamed:@"气泡-播放"]];
    view.playImg.centerX = 70;
    view.playImg.centerY = 100;
    view.playImg.height = 44;
    view.playImg.width = 44;
    [view addSubview:view.playImg];
    return view;
}



- (void)refreshData:(MessageModel *)data {
    [_message.attachment removeDelegate:self];

    _model = data;
    _message = (Y2WVideoMessage *)_model.message;
    [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.message.thumImageUrl] placeholderImage:[UIImage y2w_imageNamed:@"输入框-图片"]];
    
    [_message.attachment addDelegate:self];
    self.progress = self.message.attachment.progress;
    self.showProgress = !self.message.attachment.downloaded;
}


- (void)attachmentWillDownload:(Y2WAttachment *)attachment {
    [self refreshData:self.model];
}

- (void)attachment:(Y2WAttachment *)attachment downloadProgress:(CGFloat)progress {
    [self setProgress:progress animated:YES];
}

- (void)attachmentDidDownload:(Y2WAttachment *)attachment {
    [self refreshData:self.model];
}

@end
