//
//  ConversationListCell.h
//  API
//
//  Created by ShingHo on 16/2/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y2WUserConversation.h"
#import "Y2WSearchReslutModel.h"

@interface ConversationListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *badgeView;

@property (nonatomic, retain) Y2WUserConversation *conversation;

@property (nonatomic, retain) Y2WSearchReslutModel *searchReslutModel;

@end
