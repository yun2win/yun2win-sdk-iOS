//
//  TimeStampLabel.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "TimeStampLabel.h"

@interface TimeStampLabel ()

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UILabel *label;

@end

@implementation TimeStampLabel

- (instancetype)init {

    if (self = [super init]) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
        [self addSubview:_backgroundView];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor colorWithHexString:@"888888"];
        [self addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [_label sizeToFit];
    _label.centerX = self.frame.size.width/2;
    
    CGRect frame = _label.frame;
    frame.size.width += 20;
    frame.size.height += 2;
    _backgroundView.frame = frame;
    _backgroundView.center = _label.center;
    _backgroundView.cornerRadius = _backgroundView.frame.size.height/2;
}



- (void)setDate:(NSDate *)date {
    if (!date) {
        return;
    }
    _date = [date copy];
    _label.text = [date formattedDateWithFormat:@"MM-dd HH:mm"];

    [self setNeedsLayout];
}
@end
