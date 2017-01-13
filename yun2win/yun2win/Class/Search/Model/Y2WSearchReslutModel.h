//
//  Y2WSearchReslutModel.h
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WSearchReslutModel : NSObject

@property (nonatomic, copy) NSAttributedString *name;

@property (nonatomic, copy) NSAttributedString *text;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *targetId;


- (instancetype)initWithUserConversation:(Y2WUserConversation *)userConversation searchText:(NSString *)text;
- (instancetype)initWithUserContact:(Y2WContact *)contact searchText:(NSString *)text;
- (instancetype)initWithUserMessageBase:(MessageBase *)base searchText:(NSString *)text;

@end
