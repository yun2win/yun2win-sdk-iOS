//
//  DocumentViewController.h
//  yun2win
//
//  Created by QS on 16/10/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentItem.h"

@interface DocumentViewController : QLPreviewController

- (instancetype)initWithItems:(NSArray<DocumentItem *> *)items currentItem:(DocumentItem *)item;

@end
