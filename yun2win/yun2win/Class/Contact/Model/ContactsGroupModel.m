//
//  ContactsGroupModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ContactsGroupModel.h"

@implementation ContactsGroupModel
@synthesize groupTitle = _groupTitle;
@synthesize sortKey = _sortKey;

- (void)addContact:(ContactModel *)contact {
    [self.contacts addObject:contact];
    
    [self sort];
}

- (ContactModel *)contactModelForRowAtIndex:(NSInteger)index {
    if (index > self.contacts.count - 1) return nil;
    return self.contacts[index];
}



#pragma mark - ———— 排序 ———— -

- (void)sort {
    [self.contacts sortUsingComparator:^NSComparisonResult(NSObject<SortGroupInterface> *obj1, NSObject<SortGroupInterface> *obj2) {
        return [obj1.sortKey compare:obj2.sortKey];
    }];
}


#pragma mark - ———— getter ———— -

- (NSMutableArray *)contacts {
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}
@end
