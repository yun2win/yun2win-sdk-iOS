//
//  SettingTableViewCellModel.h
//  API
//
//  Created by QS on 16/3/9.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingTableViewCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detailTitle;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, assign) SEL cellAction;

@property (nonatomic, assign) BOOL showAccessory;

@property (nonatomic, retain) id data;

@end
