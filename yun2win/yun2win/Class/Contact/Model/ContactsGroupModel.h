//
//  ContactsGroupModel.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

@interface ContactsGroupModel : NSObject<SortGroupInterface>

@property (nonatomic, retain) NSMutableArray *contacts;

- (void)addContact:(ContactModel *)contact;

- (ContactModel *)contactModelForRowAtIndex:(NSInteger)index;

@end
