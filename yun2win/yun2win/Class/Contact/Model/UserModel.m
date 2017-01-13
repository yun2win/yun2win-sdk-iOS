//
//  UserModel.m
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize imageUrl = _imageUrl;
@synthesize image = _image;
@synthesize rowHeight = _rowHeight;
@synthesize sortKey = _sortKey;
@synthesize groupTitle = _groupTitle;
@synthesize label = _label;


- (instancetype)initWithUser:(Y2WUser *)user {
    if (self = [super init]) {
        _name = user.name;
        _uid = user.ID;
        _imageUrl = user.avatarUrl;
        _image = [UIImage y2w_imageNamed:@"默认个人头像"];
        _rowHeight = 50;
        _sortKey = user.name;
        _groupTitle = [[[user.pinyin firstObject] first] uppercaseString];
        _user = user;
    }
    return self;
}

@end
