//
//  ContactPickerConfig.m
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ContactPickerConfig.h"

@implementation ContactPickerConfig
@synthesize alreadySelectedMemberIds = _alreadySelectedMemberIds;
@synthesize filterIds = _filterIds;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize title = _title;
@synthesize maxSelectedNum = _maxSelectedNum;
@synthesize selectedOverFlowTip = _selectedOverFlowTip;

- (instancetype)init {
    if (self = [super init]) {
        self.allowsMultipleSelection = YES;
        self.title = @"选择联系人";
    }
    return self;
}

- (UserPickerType)type {
    return UserPickerTypeContact;
}

- (NSInteger)maxSelectedNum
{
    return _maxSelectedNum <= 0 ? 1000 : _maxSelectedNum;
}

- (NSString *)selectedOverFlowTip
{
    return _selectedOverFlowTip.length <= 0 ? @"选择超限" : _selectedOverFlowTip;
}

- (NSArray *)alreadySelectedMemberIds {
    if (!_alreadySelectedMemberIds) {
        _alreadySelectedMemberIds = @[];
    }
    return _alreadySelectedMemberIds;
}

- (NSArray *)filterIds {
    if (!_filterIds) {
        _filterIds = @[];
    }
    return _filterIds;
}

@end
