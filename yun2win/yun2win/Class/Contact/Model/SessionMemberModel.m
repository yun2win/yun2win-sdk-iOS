//
//  SessionMemberModel.m
//  API
//
//  Created by QS on 16/3/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "SessionMemberModel.h"

@implementation SessionMemberModel
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize imageUrl = _imageUrl;
@synthesize image = _image;
@synthesize rowHeight = _rowHeight;
@synthesize sortKey = _sortKey;
@synthesize groupTitle = _groupTitle;
@synthesize label = _label;


- (instancetype)initWithSessionMember:(Y2WSessionMember *)sessionMember {
    if (self = [super init]) {
        _name = sessionMember.name;
        _uid = sessionMember.userId.uppercaseString;
        _imageUrl = sessionMember.getAvatarUrl;
        _image = [UIImage y2w_imageNamed:@"默认个人头像"];
        _rowHeight = 50;
        _sortKey = sessionMember.name;
        _groupTitle = [[[sessionMember.pinyin firstObject] first] uppercaseString];
        _sessionMember = sessionMember;
        
        if ([sessionMember.role isEqualToString:@"master"]) {
            _label = @"群主";
            _groupTitle = @"*";
            _sortKey = [NSString stringWithFormat:@" %@",sessionMember.name];

        }else if ([sessionMember.role isEqualToString:@"admin"]) {
            _label = @"管理员";
            _groupTitle = @"*";
        }
    }
    return self;
}

@end
