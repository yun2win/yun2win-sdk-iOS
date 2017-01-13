//
//  PromptBoxView.m
//  ibama
//
//  Created by duanhongiang on 16/3/17.
//  Copyright © 2016年 ibama. All rights reserved.
//

#import "PromptBoxView.h"

#define kSelectAlertW 200.0f
#define kSelectAlertH 25.0f

@interface PromptBoxView ()

@property (nonatomic, strong)UIView         *selectAlert;       //选择框
@property (nonatomic, strong)UILabel        *titleLabel;        //标题

@end

@implementation PromptBoxView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        [self drawView];
    }
    return self;
}

//设置UI
- (void)drawView {
    if (_selectAlert == nil) {
        //弹框
        CGFloat alertW = kSelectAlertW;
        CGFloat alertH = kSelectAlertH;
        CGFloat alertX = (self.frame.size.width - alertW) / 2.0f;
        CGFloat alertY = self.frame.origin.y + kSelectAlertH + 40.0f;
        _selectAlert = [[UIView alloc] initWithFrame:CGRectMake(alertX, alertY, alertW, alertH)];
        _selectAlert.layer.cornerRadius = 10.0f;
        _selectAlert.layer.masksToBounds = YES;
        _selectAlert.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
        
        //title标题
        CGFloat titleH = kSelectAlertH;
        CGFloat titleY = 0.0f;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, titleY, alertW, titleH)];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self addSubview:_selectAlert];
        [_selectAlert addSubview:_titleLabel];
    }
}

//显示视图
- (void)show:(void (^)())back {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.alpha = 0.0f;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            
            if (back) {
                back();
            }
        });
    }];
}

//隐藏移除视图
- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setTitle:(NSString *)title{
    if (!title) { return; }
    _title = title;
    _titleLabel.text = title;
}

@end
