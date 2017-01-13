//
//  MeetingCheckCell.m
//  yunTV
//
//  Created by duanhl on 16/11/16.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "MeetingCheckCell.h"
#import "MeetingCheckModel.h"

@interface MeetingCheckCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *userImage;     //用户头像
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;     //用户名
@property (weak, nonatomic) IBOutlet UIButton       *checkButton;   //签到按钮

@end


@implementation MeetingCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkButton.layer.cornerRadius = 7.0f;
    self.checkButton.layer.masksToBounds = YES;
    self.checkButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.checkButton.layer.borderWidth = 1.0f;
}


- (void)setupData:(MeetingCheckModel *)model
{
    self.nameLabel.text = model.name;
    self.checkButton.enabled = !model.isCheck.boolValue;
}

#pragma mark 按钮点击事件
- (IBAction)checkAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(meetingCheckCell:)]) {
        [self.delegate meetingCheckCell:self];
    }
}

@end
