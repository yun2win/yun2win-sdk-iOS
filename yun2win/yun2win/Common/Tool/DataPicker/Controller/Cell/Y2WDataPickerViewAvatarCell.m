//
//  Y2WDataPickerViewAvatarCell.m
//  yun2win
//
//  Created by QS on 16/9/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WDataPickerViewAvatarCell.h"

@interface Y2WDataPickerViewAvatarCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end


@implementation Y2WDataPickerViewAvatarCell
@synthesize item = _item;
@synthesize handler = _handler;

- (void)awakeFromNib {
    [super awakeFromNib];    
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarView.cornerRadius = self.avatarView.frame.size.width/2;
}

- (IBAction)buttonClick:(id)sender {
    if (self.handler) {
        self.handler();
    }
}

- (void)setItem:(DataPickerItem *)item handler:(dispatch_block_t)handler {
    _item = item;
    _handler = handler;
    
    self.avatarView.backgroundColor = [UIColor colorWithUID:_item.ID];
    NSString *imageName = _item.folder ? @"默认群头像" : @"默认个人头像";
    [self.avatarView y2w_setImageWithY2WURLString:_item.avatarUrl placeholderImage:[UIImage y2w_imageNamed:imageName]];

    self.nameLabel.text = item.name;
    self.accessoryType = self.editingAccessoryType = _item.folder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.button.hidden = !_item.folder;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.avatarView.backgroundColor = [UIColor colorWithUID:_item.ID];
}

@end
