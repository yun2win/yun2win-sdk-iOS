//
//  Y2WVideoMessage.m
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WVideoMessage.h"

@implementation Y2WVideoMessage

- (void)updateWithDict:(NSDictionary *)dict
{
    [super updateWithDict:dict];
    
    NSMutableDictionary *content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
        if (!content[@"height"]) [content setValue:@"80" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"150" forKey:@"width"];
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
        if (!content[@"height"]) [content setValue:@"80" forKey:@"height"];
        if (!content[@"width"]) [content setValue:@"150" forKey:@"width"];
    }
    if ([self.type isEqualToString:@"movie"]) {
        self.type = @"video";
    }
    NSString *temp = content[@"src"];
    if (![[content[@"src"] substringToIndex:1] isEqualToString:@"/"]) {
        temp = [NSString stringWithFormat:@"/%@",content[@"src"]];
    }
    self.videoUrl = [NSString stringWithFormat:@"%@%@?access_token=%@",[URL baseURL],temp,[[Y2WUsers getInstance].getCurrentUser token]];
    
    NSString *tempthumbnail = content[@"thumbnail"];
    if (![[content[@"thumbnail"] substringToIndex:1] isEqualToString:@"/"]) {
        tempthumbnail = [NSString stringWithFormat:@"/%@",content[@"thumbnail"]];
    }
    self.thumImageUrl = [NSString stringWithFormat:@"%@%@?access_token=%@",[URL baseURL],tempthumbnail,[[Y2WUsers getInstance].getCurrentUser token]];
    self.text = @"[小视频]";
    
    
    
    self.attachmentId = @([content[@"src"] toInteger]).stringValue;
    self.attachment = [[Y2WUsers getInstance].getCurrentUser.attachments getAttachmentById:self.attachmentId];
}

@end
