//
//  EmailInviteCell.h
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmailInviteCell;

@protocol EmailInviteCellDelegate <NSObject>

- (void)emailInviteCell:(EmailInviteCell *)cell;

@end

@interface EmailInviteCell : UITableViewCell

- (void)setMember:(Y2WSessionMember *)member handler:(void(^)())handler;

@end
