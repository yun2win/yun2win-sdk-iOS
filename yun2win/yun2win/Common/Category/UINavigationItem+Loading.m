//
//  UINavigationItem+Loading.m
//  API
//
//  Created by QS on 16/3/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UINavigationItem+Loading.h"
#import <objc/runtime.h>

static void *LastTitleViewKey = &LastTitleViewKey;

@implementation UINavigationItem (Loading)

- (void)startAnimating {

    [self stopAnimating];
    objc_setAssociatedObject(self, LastTitleViewKey, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.titleView = indicatorView;
        [indicatorView startAnimating];
    });
}

- (void)stopAnimating {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *titleView = objc_getAssociatedObject(self, LastTitleViewKey);

        self.titleView = titleView;
    });
    
    objc_setAssociatedObject(self, LastTitleViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
