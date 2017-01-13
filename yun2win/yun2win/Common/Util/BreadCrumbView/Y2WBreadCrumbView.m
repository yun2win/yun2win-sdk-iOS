//
//  Y2WBreadCrumbView.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBreadCrumbView.h"
#import "Y2WBreadCrumbViewCell.h"

@interface Y2WBreadCrumbView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, weak) id<Y2WBreadCrumbViewDelegate>delegate;

@end


@implementation Y2WBreadCrumbView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<Y2WBreadCrumbViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor y2w_backgroundColor];
        self.delegate = delegate;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Y2WBreadCrumbViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Y2WBreadCrumbViewCell class])
                                                                            forIndexPath:indexPath];
    cell.item = self.items[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Y2WBreadCrumbItem *item = self.items[indexPath.item];
    CGSize size = [item.title stringSizeWithWidth:MAXFLOAT fontSize:15];
    return CGSizeMake(size.width + 30, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.items.count - 1) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(breadCrumbView:didSelectItemAtIndex:)]) {
        [self.delegate breadCrumbView:self didSelectItemAtIndex:indexPath.item];
    }
}


- (void)reloadData {
    [self.collectionView reloadData];
    [self updateTitleColor];
}


- (void)pushToItem:(Y2WBreadCrumbItem *)item {
    if (!self.items) {
        self.items = [NSMutableArray array];
    }
    [self.items addObject:item];
    [self reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.items.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}


- (void)popToIndex:(NSInteger)index {
    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = index + 1; i < self.items.count; i++) {
        [indexs addIndex:i];
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    [self.items removeObjectsAtIndexes:indexs];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    [self updateTitleColor];
}



- (void)updateTitleColor {
    if (!self.items.count) {
        return;
    }
    for (Y2WBreadCrumbItem *item in self.items) {
        item.titleColor = [UIColor y2w_mainColor];
    }
    [self.items.lastObject setTitleColor:[UIColor colorWithHexString:@"555555"]];
    NSInteger index = [self.items indexOfObject:self.items.lastObject];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}



- (void)setItems:(NSMutableArray<Y2WBreadCrumbItem *> *)items {
    _items = [items mutableCopy];
    
    [self reloadData];
}








- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Y2WBreadCrumbViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([Y2WBreadCrumbViewCell class])];
    }
    return _collectionView;
}

@end




@implementation Y2WBreadCrumbItem
@end
