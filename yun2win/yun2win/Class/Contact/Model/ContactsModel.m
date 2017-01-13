//
//  ContactsModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ContactsModel.h"
#import "MainViewController.h"

@interface ContactsModel ()


@end



@implementation ContactsModel

- (instancetype)init {
    
    if (self = [super init]) {
        _groupModels = [NSMutableArray array];
    }
    return self;
}


- (void)addContact:(ContactModel *)contact {
    if (!contact.groupTitle) contact.groupTitle = @"";
    if (contact.groupTitle.isIntegerNumber) {
        contact.groupTitle = @"#";
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupTitle CONTAINS[CD] %@",contact.groupTitle];
    ContactsGroupModel *groupModel = [[self.groupModels filteredArrayUsingPredicate:predicate] firstObject];

    if (!groupModel) {
        groupModel = [[ContactsGroupModel alloc] init];
        groupModel.groupTitle = contact.groupTitle;
        [self.groupModels addObject:groupModel];
    }
    

    [groupModel addContact:contact];
    
    [self sort];
}


- (ContactsGroupModel *)groupModelForRowAtSection:(NSInteger)section {
    if (section > self.groupModels.count - 1) return nil;
    return self.groupModels[section];
}

- (NSInteger)sectionForGroupTitle:(NSString *)title {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupTitle CONTAINS[CD] %@",title];
    ContactsGroupModel *groupModel = [[self.groupModels filteredArrayUsingPredicate:predicate] firstObject];
    return [self.groupModels indexOfObject:groupModel];
}


#pragma mark - ———— 组排序 ———— -

- (void)sort {
    [self.groupModels sortUsingComparator:^NSComparisonResult(NSObject<SortGroupInterface> *obj1, NSObject<SortGroupInterface> *obj2) {
        if ([obj1.groupTitle isEqualToString:@"#"]) {
            return NSOrderedDescending;
        }
        if ([obj2.groupTitle isEqualToString:@"#"]) {
            return NSOrderedAscending;
        }
        return [obj1.groupTitle compare:obj2.groupTitle];
    }];
}


- (NSArray *)titles {
    NSMutableArray *titles = [NSMutableArray array];
    for (ContactsGroupModel *model in self.groupModels) {
        if (![titles containsObject:model.groupTitle]) {
            [titles addObject:model.groupTitle];
        }
    }
    return titles;
}
@end
