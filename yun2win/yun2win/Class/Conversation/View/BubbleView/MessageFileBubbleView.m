//
//  MessageFileBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageFileBubbleView.h"
#import "Y2WFileMessage.h"

@interface MessageFileBubbleView ()<Y2WAttachmentDelegate>

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, retain) Y2WFileMessage *message;

@property (nonatomic, retain) UIImageView *iconView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *sizeLabel;

@property (nonatomic, retain) UILabel *downloadedLabel;

@property (nonatomic, retain) UIProgressView *progressView;

@property (nonatomic, retain) NSMutableDictionary *bubbleImages;

@end

@implementation MessageFileBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create {
    MessageFileBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    
    view.iconView = [[UIImageView alloc]init];
    view.iconView.top = 10;
    view.iconView.height = 50;
    view.iconView.width = 50;
    [view addSubview:view.iconView];
    
    view.nameLabel = [[UILabel alloc] init];
    view.nameLabel.top = 10;
    view.nameLabel.height = 35;
    view.nameLabel.numberOfLines = 2;
    view.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    view.nameLabel.textColor = [UIColor colorWithHexString:@"353535"];
    [view addSubview:view.nameLabel];

    view.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 45, 150, 15)];
    view.sizeLabel.font = [UIFont systemFontOfSize:11];
    view.sizeLabel.textColor = [UIColor colorWithRed:53/255 green:53/255 blue:53/255 alpha:0.5];
    [view addSubview:view.sizeLabel];
    
    view.downloadedLabel = [[UILabel alloc] init];
    view.downloadedLabel.text = @"已下载";
    view.downloadedLabel.height = view.sizeLabel.height;
    view.downloadedLabel.top = view.sizeLabel.top;
    view.downloadedLabel.font = [UIFont systemFontOfSize:11];
    view.downloadedLabel.textColor = view.sizeLabel.textColor;
    [view addSubview:view.downloadedLabel];
    [view.downloadedLabel sizeToFit];

    view.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    view.progressView.progressTintColor = [UIColor y2w_blueColor];
    view.progressView.trackTintColor = [UIColor y2w_backgroundColor];
    view.progressView.frame = CGRectMake(10, 68, 100, 2);
    [view addSubview:view.progressView];

    return view;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftMargin = !self.model.isMe * 5;
    CGFloat rightMargin = self.model.isMe * 5;
    self.iconView.left = 10 + leftMargin;
    self.nameLabel.left = 70 + leftMargin;
    self.nameLabel.width = self.width - 80 - leftMargin - rightMargin;
    self.sizeLabel.left = self.nameLabel.left;
    self.downloadedLabel.right = self.width - 15 - rightMargin;
    self.progressView.left = self.iconView.left;
    self.progressView.width = self.nameLabel.width + 60;
}


- (void)refreshData:(MessageModel *)data {
    [_message.attachment removeDelegate:self];
    
    _model = data;
    _message = (Y2WFileMessage *)data.message;

    self.iconView.image = [self distinguishFileIcon:_message.name];
    self.nameLabel.text = [_message.name stringByAppendingString:@"\n"];
    self.sizeLabel.text = [NSString fitConvertSize:_message.size];
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateNormal outgoing:data.isMe] forState:UIControlStateNormal];
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateHighlighted outgoing:data.isMe] forState:UIControlStateHighlighted];
    
    
    [_message.attachment addDelegate:self];
    self.progressView.progress = _message.attachment.progress;
    self.downloadedLabel.hidden = !self.message.attachment.downloaded;
    self.progressView.hidden = !self.message.attachment.task;
}


- (void)attachmentWillDownload:(Y2WAttachment *)attachment {
    [self refreshData:self.model];
}

- (void)attachment:(Y2WAttachment *)attachment downloadProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:YES];
}

- (void)attachmentDidDownload:(Y2WAttachment *)attachment {
    [self refreshData:self.model];
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

#pragma mark - Helper
- (UIImage *)distinguishFileIcon:(NSString *)title
{
    NSString *suffixString = [title pathExtension];
    if ([suffixString isEqualToString:@"jpeg"] ||
        [suffixString isEqualToString:@"png"] ||
        [suffixString isEqualToString:@"jpg"]) {
        return [UIImage y2w_imageNamed:@"File_image"];
    }
    if([suffixString isEqualToString:@"mp3"]){
        return [UIImage y2w_imageNamed:@"File_audio"];
    }
    if ([suffixString isEqualToString:@"mp4"]) {
        return [UIImage y2w_imageNamed:@"File_video"];
    }
    if ([suffixString isEqualToString:@"doc"] || [suffixString isEqualToString:@"docx"]) {
        return [UIImage y2w_imageNamed:@"File_doc"];
    }
    if ([suffixString isEqualToString:@"xls"] || [suffixString isEqualToString:@"xlsx"]) {
        return [UIImage y2w_imageNamed:@"File_xls"];
    }
    if ([suffixString isEqualToString:@"ppt"] || [suffixString isEqualToString:@"pptx"]) {
        return [UIImage y2w_imageNamed:@"File_ppt"];
    }
    if ([suffixString isEqualToString:@"pdf"]) {
        return [UIImage y2w_imageNamed:@"File_pdf"];
    }
    return [UIImage y2w_imageNamed:@"File_unknow"];
}

@end
