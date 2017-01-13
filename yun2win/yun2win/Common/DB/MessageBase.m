//
//  MessageBase.m
//  API
//
//  Created by QS on 16/8/31.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageBase.h"
#import "Y2WBaseMessage.h"
#import <AVFoundation/AVFoundation.h>

@implementation MessageBase

+ (NSString *)primaryKey {
    return @"ID";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"showDate": @NO,
             @"cellHeight": @0};
}

+ (instancetype)createOrUpdateInRealm:(RLMRealm *)realm withValue:(NSDictionary *)value {
    Y2WBaseMessage *message = [Y2WBaseMessage createMessageWithDict:value];
    NSMutableDictionary *dict = value.mutableCopy;
    dict[@"ID"] = message.ID;
    dict[@"text"] = message.text;
    dict[@"searchText"] = message.text.toSimpleString;
    if (!dict[@"status"]) {
        dict[@"status"] = @"stored";
    }
    dict[@"createdAt"] = [value[@"createdAt"] y2w_toDate];
    dict[@"updatedAt"] = [value[@"updatedAt"] y2w_toDate];
    dict[@"isDelete"] = @([value[@"isDelete"] boolValue]);

    MessageBase *base = [super createOrUpdateInRealm:realm withValue:dict];
    base.showDate = [base calculateNeedShowDate];
    base.cellHeight = [base calculateCellHeight];
    return base;
}

- (BOOL)calculateNeedShowDate {
    if (!self.createdAt) {
        return NO;
    }
    if ([self.status isEqualToString:@"storing"]) {
        return NO;
    }
    if ([self.type isEqualToString:@"text"] ||
        [self.type isEqualToString:@"task"] ||
        [self.type isEqualToString:@"image"] ||
        [self.type isEqualToString:@"location"] ||
        [self.type isEqualToString:@"video"] ||
        [self.type isEqualToString:@"audio"] ||
        [self.type isEqualToString:@"av"] ||
        [self.type isEqualToString:@"file"]) {
        
        MessageBase *lastBase = [[MessageBase objectsInRealm:self.realm where:@"sessionId == %@ AND createdAt < %@", self.sessionId, self.createdAt] sortedResultsUsingProperty:@"createdAt" ascending:YES].lastObject;
        
        if ([lastBase.ID isEqualToString:self.ID]) {
            return NO;
        }
        return [lastBase.createdAt minutesEarlierThan:self.createdAt] > 3;
    }
    return NO;
}


- (CGFloat)calculateCellHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat timeStampHeight = MessageFrame.timeStampHeight;
    CGFloat avatarMargin = MessageFrame.avatarMargin;
    CGFloat avatarSize = MessageFrame.avatarSize;
    CGFloat avatar_content_margin = 3;
    CGFloat contentMargin = 50;
    
    CGRect timeStampFrame = CGRectMake(0, 0, width, timeStampHeight * self.showDate);
    CGRect avatarFrame = CGRectMake(0, timeStampFrame.size.height + 10, avatarSize, avatarSize);
    CGSize contentSize = CGSizeZero;
    
    if ([self.type isEqualToString:@"text"] || [self.type isEqualToString:@"task"]) {
        UIEdgeInsets contentViewInsets = UIEdgeInsetsMake(10, 10, 10, 15);
        contentSize = [self.text sizeAttributedWithWidth:width - avatarMargin - avatar_content_margin - contentMargin - timeStampHeight - contentViewInsets.left - contentViewInsets.right];
        contentSize.width += (contentViewInsets.left + contentViewInsets.right);
        contentSize.height += (contentViewInsets.top + contentViewInsets.bottom);
        
        if (contentSize.height < 32) {
            contentSize.height = 32;
        }
        
    }
    else if ([self.type isEqualToString:@"location"] || [self.type isEqualToString:@"video"] || [self.type isEqualToString:@"image"]){
        NSDictionary *contentDict = self.content.parseJsonString;
        CGFloat width = [contentDict[@"width"] floatValue] ?: 150;
        CGFloat height = [contentDict[@"height"] floatValue] ?: 80;
        CGSize size = CGSizeMake(width, height);
        contentSize = AVMakeRectWithAspectRatioInsideRect(size,CGRectMake(0, 0, 200, 200)).size;
    }
    else if ([self.type isEqualToString:@"audio"]) {
        contentSize.width = 128;
        contentSize.height = 36;
    }
    else if([self.type isEqualToString:@"file"] || [self.type isEqualToString:@"av"]) {
        contentSize.width = width * 0.7;
        contentSize.height = 80;
    }
    
    return avatarFrame.origin.y + contentSize.height + 20;
}




- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.ID) dict[@"id"] = self.ID;
    if (self.sessionId) dict[@"sessionId"] = self.sessionId;
    if (self.sender) dict[@"sender"] = self.sender;
    if (self.type) dict[@"type"] = self.type;
    if (self.content) dict[@"content"] = self.content;
    if (self.createdAt.y2w_toString) dict[@"createdAt"] = self.createdAt.y2w_toString;
    if (self.updatedAt.y2w_toString) dict[@"updatedAt"] = self.updatedAt.y2w_toString;
    if (self.showDate) dict[@"isShowTimestamp"] = @(self.showDate);
    if (self.status) dict[@"status"] = self.status;
    return dict;
}

@end








@implementation MessageFrame

+ (CGFloat)avatarSize {
    return 32;
}

+ (CGFloat)avatarMargin {
    return 10;
}

+ (CGFloat)timeStampHeight {
    return 30;
}

+ (CGFloat)textFontSize {
    return 15;
}

@end
