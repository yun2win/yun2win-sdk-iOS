//
//  Y2WAudioMessage.m
//  API
//
//  Created by ShingHo on 16/4/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WAudioMessage.h"

@implementation Y2WAudioMessage

- (void)updateWithDict:(NSDictionary *)dict
{
    [super updateWithDict:dict];
    
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
    }
    self.audioUrl = [NSString stringWithFormat:@"/%@%@?access_token=%@",[URL baseURL],content[@"src"],[[Y2WUsers getInstance].getCurrentUser token]];
    self.text = @"[音频]";
    
    
    
    self.attachmentId = @([content[@"src"] toInteger]).stringValue;
}

@end
