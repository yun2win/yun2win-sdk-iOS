//
//  ContactsModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MemberGroupsModel.h"
#import "MainViewController.h"

@interface MemberGroupsModel ()


@end



@implementation MemberGroupsModel

- (instancetype)init {
    
    if (self = [super init]) {
        _groupModels = [NSMutableArray array];
    }
    return self;
}


- (void)addContact:(NSObject<MemberModelInterface> *)contact {
    if (!contact.groupTitle) contact.groupTitle = @"";
    if (contact.groupTitle.isIntegerNumber) {
        contact.groupTitle = @"#";
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupTitle CONTAINS[CD] %@",contact.groupTitle];
    MemberGroupModel *groupModel = [[self.groupModels filteredArrayUsingPredicate:predicate] firstObject];

    if (!groupModel) {
        groupModel = [[MemberGroupModel alloc] init];
        groupModel.groupTitle = contact.groupTitle;
        [self.groupModels addObject:groupModel];
    }
    
    [groupModel addContact:contact];
    
    [self sort];
}


- (MemberGroupModel *)groupModelForRowAtSection:(NSInteger)section {
    if (section > self.groupModels.count - 1) return nil;
    return self.groupModels[section];
}

- (NSInteger)sectionForGroupTitle:(NSString *)title {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupTitle CONTAINS[CD] %@",title];
    MemberGroupModel *groupModel = [[self.groupModels filteredArrayUsingPredicate:predicate] firstObject];
    return [self.groupModels indexOfObject:groupModel];
}

- (NSIndexPath *)indexPathForUID:(NSString *)uid {
    uid = uid.uppercaseString;
    
    for (MemberGroupModel *group in self.groupModels) {
        
        for (NSObject<MemberModelInterface> *member in group.contacts) {
            
            if ([member.uid.uppercaseString isEqualToString:uid]) {
                NSInteger row = [self.groupModels indexOfObject:group];
                NSInteger section = [group indexOfAccessibilityElement:member];
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    
    return nil;
}




#pragma mark - ———— 组排序 ———— -

- (void)sort {
    [self.groupModels sortUsingComparator:^NSComparisonResult(NSObject<SortGroupInterface> *obj1, NSObject<SortGroupInterface> *obj2) {
        if ([obj1.groupTitle isEqualToString:@"*"]) {
            return NSOrderedAscending;
        }
        if ([obj2.groupTitle isEqualToString:@"*"]) {
            return NSOrderedDescending;
        }
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
    for (MemberGroupModel *model in self.groupModels) {
        if (![titles containsObject:model.groupTitle]) {
            [titles addObject:model.groupTitle];
        }
    }
    return titles;
}

@end
