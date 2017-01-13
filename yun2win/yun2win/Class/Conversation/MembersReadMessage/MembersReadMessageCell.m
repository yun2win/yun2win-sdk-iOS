//
//  MembersReadMessageCell.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MembersReadMessageCell.h"

@interface MembersReadMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation MembersReadMessageCell

- (void)setMember:(Y2WSessionMember *)member {
    self.avatar.backgroundColor = [UIColor colorWithUID:member.userId];
    [self.avatar y2w_setImageWithY2WURLString:member.getAvatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
    [self.nameLabel setText:member.name];
}

@end
