//
//  Y2WDataPickerViewController.m
//  yun2win
//
//  Created by QS on 16/9/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WDataPickerViewController.h"
#import "Y2WDataPickerController.h"
#import "Y2WDataPickerViewAvatarCell.h"
#import "Y2WDataPickerViewTextCell.h"
#import "DataPickerItem.h"

@interface Y2WDataPickerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray<DataPickerItem *> *items;

@end



@implementation Y2WDataPickerViewController

- (instancetype)initWithItems:(NSArray<DataPickerItem *> *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.editing = [(Y2WDataPickerController *)self.navigationController model].multiple;
    self.tableView.allowsMultipleSelection = self.tableView.editing;
    self.tableView.allowsMultipleSelectionDuringEditing = self.tableView.editing;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Y2WDataPickerViewAvatarCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([Y2WDataPickerViewAvatarCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Y2WDataPickerViewTextCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([Y2WDataPickerViewTextCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets = [(Y2WDataPickerController *)self.navigationController contentInset];
}

- (void)reloadData {
    for (DataPickerItem *item in self.items) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.items indexOfObject:item] inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

        if ([(Y2WDataPickerController *)self.navigationController isSelectedItem:item]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}





#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerItem *item = self.items[indexPath.row];
    Class cellClass = [(Y2WDataPickerController *)self.navigationController model].avatar ? [Y2WDataPickerViewAvatarCell class] :
                                                                                            [Y2WDataPickerViewTextCell class];

    UITableViewCell<Y2WDataPickerViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (![(Y2WDataPickerController *)self.navigationController model].multiple) {
        cell.selectedBackgroundView = nil;
    }

    [cell setItem:item handler:^{
        [(Y2WDataPickerController *)self.navigationController pushItem:self.items[indexPath.row]];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerItem *item = self.items[indexPath.row];
    return !(![(Y2WDataPickerController *)self.navigationController model].selectFolder && item.folder);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerItem *item = self.items[indexPath.row];
    if (![self tableView:tableView canEditRowAtIndexPath:indexPath]) {
        [(Y2WDataPickerController *)self.navigationController pushItem:self.items[indexPath.row]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    [(Y2WDataPickerController *)self.navigationController selectItem:item];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPickerItem *item = self.items[indexPath.row];
    if (![self tableView:tableView canEditRowAtIndexPath:indexPath]) {
        [(Y2WDataPickerController *)self.navigationController pushItem:item];
        return;
    }
    [(Y2WDataPickerController *)self.navigationController deselectItem:item];
}


@end
