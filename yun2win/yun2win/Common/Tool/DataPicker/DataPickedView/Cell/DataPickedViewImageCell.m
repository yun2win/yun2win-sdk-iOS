//
//  DataPickedViewImageCell.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataPickedViewImageCell.h"
#import "DataPickerItem.h"

@interface DataPickedViewImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation DataPickedViewImageCell
@synthesize item = _item;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.cornerRadius = self.imageView.frame.size.width/2;
}



- (void)setItem:(DataPickerItem *)item {
    _item = item;
    
    self.imageView.backgroundColor = [UIColor colorWithUID:_item.ID];
    NSString *imageName = _item.folder ? @"默认群头像" : @"默认个人头像";
    [self.imageView y2w_setImageWithY2WURLString:_item.avatarUrl placeholderImage:[UIImage y2w_imageNamed:imageName]];

    [self layoutIfNeeded];
    [self setNeedsLayout];
}

@end
