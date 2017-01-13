//
//  DataPickedViewTextCell.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataPickedViewTextCell.h"
#import "DataPickerItem.h"

@interface DataPickedViewTextCell ()

@property (weak, nonatomic) IBOutlet UIView *borderView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation DataPickedViewTextCell
@synthesize item = _item;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.textColor = [UIColor y2w_mainColor];
    self.borderView.layer.borderWidth = 0.5;
    self.borderView.layer.borderColor = [UIColor y2w_mainColor].CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.borderView.layer.cornerRadius = self.borderView.frame.size.height/2;
}


- (void)setItem:(DataPickerItem *)item {
    _item = item;
    self.textLabel.text = _item.name;
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

@end
