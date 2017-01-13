//
//  UserPickerConfig.h
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, UserPickerType) {
    UserPickerTypeContact,
    UserPickerTypeSessionMember,
};


@protocol UserPickerConfig <NSObject>

@optional

@property (nonatomic, retain) NSArray *alreadySelectedMemberIds; // 默认已经勾选的人或群组

@property (nonatomic, retain) NSArray *filterIds; // 需要过滤的人或群组id

@property (nonatomic, assign) BOOL allowsMultipleSelection; // 是否允许多选

@property (nonatomic, copy) NSString *title; // 标题

@property (nonatomic, assign) NSInteger maxSelectedNum;   //最多选择的人数
@property (nonatomic, copy) NSString *selectedOverFlowTip; //超过最多选择人数时的提示

/**
 *  联系人选择器中的数据源类型
 */
- (UserPickerType)type;

@end
