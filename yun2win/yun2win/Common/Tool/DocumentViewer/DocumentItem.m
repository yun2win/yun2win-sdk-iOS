//
//  DocumentItem.m
//  yun2win
//
//  Created by QS on 16/10/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DocumentItem.h"

@interface DocumentItem ()

@property (nonatomic, retain) NSURL *url;

@property (nonatomic, copy) NSString *title;

@end


@implementation DocumentItem
@dynamic previewItemURL;
@dynamic previewItemTitle;

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    if (self = [super init]) {
        self.url = url;
        self.title = title;
    }
    return self;
}


- (NSURL *)previewItemURL {
    return self.url;
}

- (NSString *)previewItemTitle {
    return self.title;
}

@end
