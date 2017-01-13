//
//  ServiceSearchModel.h
//  yun2win
//
//  Created by duanhl on 16/11/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServiceSearchModel;

@interface ServiceSearchModel : NSObject

@property (nonatomic, assign) BOOL      enable;
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *url;

+(ServiceSearchModel *)createSearchModel:(NSDictionary *)dic;

@end
