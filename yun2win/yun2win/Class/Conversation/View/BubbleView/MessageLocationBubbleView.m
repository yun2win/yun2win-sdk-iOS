//
//  MessageLocationBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageLocationBubbleView.h"
#import "Y2WLocationMessage.h"

@interface MessageLocationBubbleView ()

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation MessageLocationBubbleView
@synthesize messageDelegate = _messageDelegate;

+ (instancetype)create
{
    MessageLocationBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    

    view.addressLabel = [[UILabel alloc]init];
    view.addressLabel.textAlignment = NSTextAlignmentCenter;
    view.addressLabel.backgroundColor = [UIColor colorWithRed:53/255 green:53/255 blue:53/255 alpha:0.5];
    view.addressLabel.textColor = [UIColor whiteColor];
    view.addressLabel.font = [UIFont systemFontOfSize:12];
    view.addressLabel.left = 0;
    view.addressLabel.height = 30;
    [view addSubview:view.addressLabel];
        
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.addressLabel.width = self.frame.size.width;
    self.addressLabel.top = self.frame.size.height - 30;
}

- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WLocationMessage *message = (Y2WLocationMessage *)temp_message;
    
    [self y2w_setImageForState:UIControlStateNormal withY2WURLString:message.thumImageUrl placeholderImage:[UIImage y2w_imageNamed:@"输入框-图片"]];
    self.addressLabel.text = message.title;
}

@end
