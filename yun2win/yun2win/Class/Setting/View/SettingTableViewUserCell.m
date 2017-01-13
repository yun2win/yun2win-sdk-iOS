//
//  SettingTableViewUserCell.m
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SettingTableViewUserCell.h"
#import "Y2WCurrentUser.h"

@implementation SettingTableViewUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.layer.masksToBounds = YES;
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    self.imageView.left = 15;
    self.imageView.width = self.imageView.height = self.height - 20;
    self.imageView.centerY = self.height/2;
    self.imageView.layer.cornerRadius = self.imageView.width/2;
    
    self.textLabel.top = 17;
    self.textLabel.left = self.detailTextLabel.left = self.imageView.left + self.imageView.width + 10;
    
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.bottom = self.height - 17;
}

- (void)relodData:(SettingTableViewCellModel *)data tableView:(UITableView *)tableView {
    [super relodData:data tableView:tableView];
    
    self.imageView.backgroundColor = [UIColor colorWithUID:data.uid];
    [self.imageView y2w_setImageWithY2WURLString:data.avatarUrl placeholderImage:data.image];
}

@end
