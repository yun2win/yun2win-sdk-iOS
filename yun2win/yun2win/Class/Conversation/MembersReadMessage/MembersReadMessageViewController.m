//
//  MembersReadMessageViewController.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MembersReadMessageViewController.h"
#import "MembersReadMessageCell.h"

@interface MembersReadMessageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MembersReadMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MembersReadMessageCell" bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([MembersReadMessageCell class])];
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MembersReadMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MembersReadMessageCell class]) forIndexPath:indexPath];
    cell.member = self.members[indexPath.item];
    return cell;
}





- (void)setMembers:(NSArray *)members {
    _members = members.copy;
    
    if (_collectionView) {
        [self.collectionView reloadData];
    }
}

@end
