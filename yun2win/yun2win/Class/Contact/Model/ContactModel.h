//
//  ContactModel.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortGroupInterface.h"
#import "MemberModelInterface.h"

@interface ContactModel : NSObject<MemberModelInterface>

@property (nonatomic, retain) NSMutableArray *members;

@property (nonatomic, retain) Y2WContact *contact;

- (instancetype)initWithContact:(Y2WContact *)contact;

@end
