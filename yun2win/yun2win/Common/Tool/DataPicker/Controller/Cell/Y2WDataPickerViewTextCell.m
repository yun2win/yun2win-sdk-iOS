//
//  Y2WDataPickerViewTextCell.m
//  yun2win
//
//  Created by QS on 16/9/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WDataPickerViewTextCell.h"

@interface Y2WDataPickerViewTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end


@implementation Y2WDataPickerViewTextCell
@synthesize item = _item;
@synthesize handler = _handler;

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.button setBackgroundImage:[UIImage imageWithUIColor:[UIColor y2w_mainColor]] forState:UIControlStateNormal];
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (IBAction)buttonClick:(id)sender {
    if (self.handler) {
        self.handler();
    }
}

- (void)setItem:(DataPickerItem *)item handler:(dispatch_block_t)handler {
    _item = item;
    _handler = handler;
    
    self.nameLabel.text = item.name;
    self.accessoryType = self.editingAccessoryType = _item.folder ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.button.hidden = !_item.folder;
}

@end
