//
//  ContactsGroupModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MemberGroupModel.h"

@implementation MemberGroupModel
@synthesize groupTitle = _groupTitle;
@synthesize sortKey = _sortKey;

- (void)addContact:(NSObject<MemberModelInterface> *)contact {
    [self.contacts addObject:contact];
    
    [self sort];
}

- (NSObject<MemberModelInterface> *)contactModelForRowAtIndex:(NSInteger)index {
    if (index > self.contacts.count - 1) return nil;
    return self.contacts[index];
}


#pragma mark - ———— 排序 ———— -

- (void)sort {

    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"sortKey" ascending:YES];
    [self.contacts sortUsingDescriptors:@[sort2]];
}


#pragma mark - ———— getter ———— -

- (NSMutableArray *)contacts {
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}
@end
