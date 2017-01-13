//
//  ContactTableViewCell.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModelInterface.h"

@interface MemberModelCell : UITableViewCell

@property (nonatomic,strong) UIButton *avatarImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *label;

@property (nonatomic, retain) NSObject<MemberModelInterface> *model;

@end
