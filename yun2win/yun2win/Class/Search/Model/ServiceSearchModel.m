//
//  ServiceSearchModel.m
//  yun2win
//
//  Created by duanhl on 16/11/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ServiceSearchModel.h"

@implementation ServiceSearchModel

+(ServiceSearchModel *)createSearchModel:(NSDictionary *)dic
{
    ServiceSearchModel *model = [[ServiceSearchModel alloc] init];
    model.enable = [[dic objectForKey:@"enable"] boolValue];
    model.name = [dic objectForKey:@"name"];
    model.title = [dic objectForKey:@"title"];
    model.url = [dic objectForKey:@"url"];

    return model;
}



@end
