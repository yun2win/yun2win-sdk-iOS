//
//  Y2WSystemMessage.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSystemMessage.h"

@implementation Y2WSystemMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    id content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }
    
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
        
    }else if ([content isKindOfClass:[NSString class]]) {
        self.content = @{@"text": content};
        
    }else {
        self.content = @{@"text": dict[@"content"]};
    }
    self.text = self.content[@"text"];
    
    if (!self.text) {
        self.text = @"未知类型消息，请在其它客户端查看";
    }
}

@end
