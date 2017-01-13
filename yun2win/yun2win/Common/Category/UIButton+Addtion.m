//
//  UIButton+Addtion.m
//  API
//
//  Created by QS on 16/9/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UIButton+Addtion.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, copy) void (^block) (UIButton *);

@end

@implementation UIButton (QSblock)

- (void)addHandler:(void (^)(UIButton *))block {
    self.block = block;
    [self addTarget:self action:@selector(handle) forControlEvents:1<<6];
}

- (void)handle {
    if (self.block) {
        self.block(self);
    }
}






- (void)setBlock:(void (^)(UIButton *))block {
    objc_setAssociatedObject(self, @"block", block, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UIButton *))block {
    return objc_getAssociatedObject(self, @"block");
}

@end





@implementation UIButton (QSProgress)
@dynamic showProgress;
@dynamic progress;
const NSInteger MASKPROGRESSVIEW_TAG = 135223235;

- (void)setShowProgress:(BOOL)showProgress {
    self.maskProgressView.hidden = !showProgress;
    [self updateProgress];
    objc_setAssociatedObject(self,@"showProgress", @(showProgress), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)showProgress {
    return [objc_getAssociatedObject(self, @"showProgress") boolValue];
}

- (void)setProgress:(CGFloat )progress {
    objc_setAssociatedObject(self,@"progress", @(progress), OBJC_ASSOCIATION_RETAIN);
    [self updateProgress];
}
- (CGFloat)progress {
    return [objc_getAssociatedObject(self, @"progress") floatValue];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self updateProgress];
    if (!animated) {
        self.progress = progress;
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.progress = progress;
    }];
}

- (void)updateProgress {
    if (![self showProgress]) {
        return;
    }
    CGRect frame = self.bounds;
    frame.size.height = frame.size.height * (1 - self.progress);
    frame.origin.y = self.bounds.size.height - frame.size.height;
    self.maskProgressView.frame = frame;
}


- (UIView *)maskProgressView {
    UIView *view = [self viewWithTag:MASKPROGRESSVIEW_TAG];
    if (!view) {
        view = [[UIView alloc] initWithFrame:self.bounds];
        view.tag = MASKPROGRESSVIEW_TAG;
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        [self sendSubviewToBack:view];
    }
    return view;
}

@end

