//
//  Y2WBreadCrumbView.h
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Y2WBreadCrumbView,Y2WBreadCrumbItem;


@protocol Y2WBreadCrumbViewDelegate <NSObject>

- (void)breadCrumbView:(Y2WBreadCrumbView *)view didSelectItemAtIndex:(NSInteger)index;

@end

@interface Y2WBreadCrumbView : UIView

@property (nonatomic, retain) NSMutableArray<Y2WBreadCrumbItem *> *items;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<Y2WBreadCrumbViewDelegate>)delegate;


- (void)pushToItem:(Y2WBreadCrumbItem *)item;

- (void)popToIndex:(NSInteger)index;

@end


@interface Y2WBreadCrumbItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, retain) UIColor *titleColor;

@end
