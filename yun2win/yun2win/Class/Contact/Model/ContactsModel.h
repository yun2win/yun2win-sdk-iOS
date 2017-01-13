//
//  ContactsModel.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsGroupModel.h"
#import "ContactModel.h"

@interface ContactsModel : NSObject

@property (nonatomic, retain) NSMutableArray *groupModels;

- (NSArray *)titles;

- (void)addContact:(ContactModel *)contact;

- (ContactsGroupModel *)groupModelForRowAtSection:(NSInteger)section;

- (NSInteger)sectionForGroupTitle:(NSString *)title;

@end
