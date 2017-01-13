//
//  DocumentItem.h
//  yun2win
//
//  Created by QS on 16/10/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@import QuickLook;

@interface DocumentItem : NSObject<QLPreviewItem>

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title;

@end
