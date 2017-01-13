//
//  FavorGroupCell.m
//  API
//
//  Created by ShingHo on 16/8/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "FavorGroupCell.h"

@interface FavorGroupCell()

@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation FavorGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.switchView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.switchView.right = self.contentView.width - 10;
    self.switchView.top = 10;
    self.switchView.width = 100;
    self.switchView.height = 40;
}

- (void)relodData:(SettingTableViewCellModel *)data tableView:(UITableView *)tableView {
    [super relodData:data tableView:tableView];
    self.switchView.on = data.showAccessory;
}

@end
