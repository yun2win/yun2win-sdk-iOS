//
//  ContactsModel.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberGroupModel.h"
#import "ContactModel.h"

@interface MemberGroupsModel : NSObject

@property (nonatomic, retain) NSMutableArray *groupModels;

- (NSArray *)titles;

- (void)addContact:(NSObject<MemberModelInterface> *)contact;

- (MemberGroupModel *)groupModelForRowAtSection:(NSInteger)section;

- (NSInteger)sectionForGroupTitle:(NSString *)title;


- (NSIndexPath *)indexPathForUID:(NSString *)uid;

@end
