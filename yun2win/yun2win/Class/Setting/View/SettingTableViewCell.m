//
//  SettingTableViewCell.m
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "UIView+Layout.h"

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)relodData:(SettingTableViewCellModel *)data tableView:(UITableView *)tableView {
    
    self.textLabel.text = data.title;
    self.detailTextLabel.text = data.detailTitle;
    self.accessoryType = data.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

@end
