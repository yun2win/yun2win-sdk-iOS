//
//  EmailInviteCell.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "EmailInviteCell.h"

@interface EmailInviteCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (nonatomic, copy) dispatch_block_t handler;

@end


@implementation EmailInviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.inviteButton setBackgroundImage:[UIImage imageWithUIColor:[UIColor y2w_mainColor]] forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteButtonClick) forControlEvents:1<<6];
}

- (void)inviteButtonClick {
    if (self.handler) {
        self.handler();
    }
}

- (void)setMember:(Y2WSessionMember *)member handler:(void (^)())handler {
    [self.nameLabel setText:member.userId];
    [self.inviteButton setTitle:[NSString stringWithFormat:@"再次邀请(%@)",@(member.time)] forState:UIControlStateNormal];
    self.handler = handler;
}

@end
