//
//  ContactsGroupModel.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"

@interface MemberGroupModel : NSObject<SortGroupInterface>

@property (nonatomic, retain) NSMutableArray<NSObject<MemberModelInterface> *> *contacts;

- (void)addContact:(NSObject<MemberModelInterface> *)contact;

- (NSObject<MemberModelInterface> *)contactModelForRowAtIndex:(NSInteger)index;

@end
