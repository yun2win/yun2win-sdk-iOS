//
//  DataPickedView.m
//  yun2win
//
//  Created by QS on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "DataPickedView.h"
#import "DataPickerItem.h"

@interface DataPickedView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, assign) id<DataPickedViewDelegate> delegate;

@property (nonatomic, retain) NSMutableArray<DataPickerItem *> *items;

@end


@implementation DataPickedView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DataPickedViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        self.items = [NSMutableArray array];

        self.delegate = delegate;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)reloadData {
    [self.collectionView reloadData];
}


- (void)pushItem:(DataPickerItem *)item {
    [self.items addObject:item];
    [self reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.items.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)removeItem:(DataPickerItem *)item {
    NSInteger index = NSNotFound;
    for (DataPickerItem *_item in self.items) {
        if ([item isEqual:_item]) {
            index = [self.items indexOfObject:_item];
            break;
        }
    }
    if (index != NSNotFound) {
        [self.items removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerItem *item = self.items[indexPath.item];
    Class cellClass = self.avatar ? [DataPickedViewImageCell class] : [DataPickedViewTextCell class];
    UICollectionViewCell<DataPickedViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass)
                                                                                          forIndexPath:indexPath];
    cell.item = item;
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.avatar) {
        return CGSizeMake(self.frame.size.height, self.frame.size.height);
    }
    
    DataPickerItem *item = self.items[indexPath.item];
    CGSize size = [item.name stringSizeWithWidth:MAXFLOAT fontSize:15];
    return CGSizeMake(size.width + 35, self.frame.size.height);
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(dataPickedView:didSelectItem:)]) {
        [self.delegate dataPickedView:self didSelectItem:self.items[indexPath.item]];
    }
}




#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DataPickedViewTextCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([DataPickedViewTextCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DataPickedViewImageCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([DataPickedViewImageCell class])];
    }
    return _collectionView;
}

@end
