//
//  Y2WFileMessage.m
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WFileMessage.h"
#import "Y2WAttachment.h"

@implementation Y2WFileMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
    }
    
    self.name = content[@"name"];
    self.size = [content[@"size"] integerValue];
    self.text = @"[文件]";
    
    self.attachmentId = @([content[@"src"] toInteger]).stringValue;
    self.attachment = [[Y2WUsers getInstance].getCurrentUser.attachments getAttachmentById:self.attachmentId];
    
    //    self.fileUrl = [NSString stringWithFormat:@"%@%@?access_token=%@",[URL baseURL],content[@"src"],[[Y2WUsers getInstance].getCurrentUser token]];
}

@end
