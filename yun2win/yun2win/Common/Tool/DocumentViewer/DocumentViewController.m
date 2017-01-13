//
//  DocumentViewController.m
//  yun2win
//
//  Created by QS on 16/10/6.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@property (nonatomic, retain) NSArray<DocumentItem *> *items;

@end



@implementation DocumentViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (UIView *tempView in self.view.subviews) {
        for (UIView *tempView2 in tempView.subviews) {
            if ([tempView2 isKindOfClass:[UINavigationBar class]]) {
                for (UIView *tempView3 in tempView2.subviews) {
                    NSLog(@"class2==%@",tempView3);
                }
            }
        }
    }

}


- (instancetype)initWithItems:(NSArray<DocumentItem *> *)items currentItem:(DocumentItem *)item {
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
        self.items = items;
        
        if (item) {
            NSInteger index = [self.items indexOfObject:item];
            if (index != NSNotFound) {
                self.currentPreviewItemIndex = index;
            }
        }
    }
    return self;
}


#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.items.count;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.items[index];
}





#pragma mark - setter

- (void)setItems:(NSArray<DocumentItem *> *)items {
    _items = items.copy;
    [self reloadData];
}

@end
