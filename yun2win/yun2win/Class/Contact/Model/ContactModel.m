//
//  ContactModel.m
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize imageUrl = _imageUrl;
@synthesize image = _image;
@synthesize rowHeight = _rowHeight;
@synthesize sortKey = _sortKey;
@synthesize groupTitle = _groupTitle;
@synthesize label = _label;

- (instancetype)initWithContact:(Y2WContact *)contact {
    if (self = [super init]) {
        _name = contact.getName;
        _uid = contact.userId.uppercaseString;
        _imageUrl = contact.getAvatarUrl;
        _image = [UIImage y2w_imageNamed:@"默认个人头像"];
        _rowHeight = 50;
        _sortKey = contact.getName;
        _groupTitle = [[[contact.pinyin firstObject] first] uppercaseString];
        _contact = contact;
    }
    return self;
}

@end
