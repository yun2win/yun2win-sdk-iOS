//
//  ContactTableViewCell.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModelInterface.h"

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, retain) NSObject<MemberModelInterface> *model;

@end
