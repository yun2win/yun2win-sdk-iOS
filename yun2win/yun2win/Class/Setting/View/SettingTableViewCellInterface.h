//
//  SettingTableViewCellInterface.h
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingTableViewCellModel.h"

@protocol SettingTableViewCellInterface <NSObject>
@optional
- (void)relodData:(SettingTableViewCellModel *)data tableView:(UITableView *)tableView;

@end
