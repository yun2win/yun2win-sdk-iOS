//
//  Y2WLocationMessage.m
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WLocationMessage.h"

@implementation Y2WLocationMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
        if (!content[@"height"]) [content setValue:@"160" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"284" forKey:@"width"];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
        if (!content[@"height"]) [content setValue:@"160" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"284" forKey:@"width"];
    }

    self.thumImageUrl = content[@"thumbnail"];
    self.title = content[@"title"];
    self.text = @"[位置]";
}

@end
