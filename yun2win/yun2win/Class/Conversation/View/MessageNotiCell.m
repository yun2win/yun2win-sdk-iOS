//
//  MessageNotiCell.m
//  API
//
//  Created by QS on 16/3/17.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageNotiCell.h"

@implementation MessageNotiCell
@synthesize messageDelegate = _messageDelegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
        self.contentView.clipsToBounds = YES;
        
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor colorWithHexString:@"888888"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    
    self.contentView.width = self.textLabel.width + 20;
    self.contentView.height = self.textLabel.height + 2;
    self.contentView.centerX = self.width/2;
    self.contentView.centerY = self.height/2;
    self.contentView.layer.cornerRadius = self.contentView.height/2;
    
    self.textLabel.centerX = self.contentView.width/2;
    self.textLabel.centerY = self.contentView.height/2;
}

- (void)refreshData:(MessageModel *)data {
    self.textLabel.text = data.message.content[@"text"];
}

@end
