//
//  MoreInputView.m
//  API
//
//  Created by QS on 16/3/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MoreInputView.h"
//#import "MoreItem.h"

@interface MoreInputView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;

@end


@implementation MoreInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}




#pragma mark - ———— UICollectionViewDataSource ———— -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreItem *model = self.items[indexPath.item];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:998];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.width)];
        [cell.contentView addSubview:imageView];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:999];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.width + 5, cell.width, 20)];
        label.tag = 999;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
    }

    
    imageView.backgroundColor = [UIColor clearColor];
    
    imageView.image = model.image;
    label.text = model.title;
    
    return cell;
}


#pragma mark - ———— UICollectionViewDelegate ———— -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(moreInputViewDidSelectItem:)]) {
        [self.delegate moreInputViewDidSelectItem:self.items[indexPath.item]];
    }
}





#pragma mark - ———— setter ———— -

- (void)setItems:(NSArray *)items {
    _items = items;
    [self.collectionView reloadData];
}



#pragma mark - ———— getter ———— -

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(56, 85);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

@end
