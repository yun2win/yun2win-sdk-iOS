//
//  Y2WBreadCrumbViewCell.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBreadCrumbViewCell.h"
#import "Y2WBreadCrumbView.h"

@interface Y2WBreadCrumbViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation Y2WBreadCrumbViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithHexString:@"DDDDDD"] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(rect.size.width - 16, 0);
    [path moveToPoint:point];
    point = CGPointMake(rect.size.width, rect.size.height/2);
    [path addLineToPoint:point];
    point = CGPointMake(rect.size.width - 16, rect.size.height);
    [path addLineToPoint:point];
    [path stroke];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
//    self.backgroundColor = highlighted ? [self.item.titleColor colorWithAlphaComponent:0.5] : [UIColor clearColor];
    self.titleLabel.textColor = highlighted ? [self.item.titleColor colorWithAlphaComponent:0.2] : self.item.titleColor;
}

- (void)setItem:(Y2WBreadCrumbItem *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.titleLabel.textColor = item.titleColor;
    [self setNeedsDisplay];
}



//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    [self setNeedsDisplay];
//    [self layoutIfNeeded];
//    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
//    CGRect newFrame = layoutAttributes.frame;
//    newFrame.size.width = ceilf(size.width);
//    layoutAttributes.frame = newFrame;
//    return layoutAttributes;
//}

@end
