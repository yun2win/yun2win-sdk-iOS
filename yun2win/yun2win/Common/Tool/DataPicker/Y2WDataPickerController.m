//
//  Y2WDataPickerController.m
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WDataPickerController.h"
#import "Y2WDataPickerViewController.h"
#import "Y2WBreadCrumbView.h"
#import "DataPickedView.h"

@interface Y2WDataPickerController ()<UINavigationControllerDelegate,DataPickedViewDelegate,Y2WBreadCrumbViewDelegate>

@property (nonatomic, copy) void(^handler)(NSArray *ids);

@property (nonatomic, retain) Y2WBreadCrumbView *breadCrumbView;

@property (nonatomic, retain) DataPickedView *pickedView;

@property (nonatomic, retain) UIBarButtonItem *cancelItem;

@property (nonatomic, retain) UIBarButtonItem *doneItem;

@end


@implementation Y2WDataPickerController

- (instancetype)initWithModel:(DataPickerModel *)model handler:(void(^)(NSArray *ids))handler {
    if (self = [super init]) {
        self.model = model;
        self.handler = handler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    

    if (self.model.multiple) {
        [self.view addSubview:self.pickedView];
    }
    [self.view addSubview:self.breadCrumbView];
    
    [self setupModel:self.model];
    [self updateDoneItem];
}


- (void)setupModel:(DataPickerModel *)model {
    Y2WDataPickerViewController *dataPickerVC = [[Y2WDataPickerViewController alloc] initWithItems:model.dataSource];
    dataPickerVC.title = model.title;
    [self pushViewController:dataPickerVC animated:YES];
    
    NSDictionary *selected = self.model.selected.copy;
    for (NSString *key in selected) {
        [self.pickedView pushItem:selected[key]];
    }
    
    Y2WBreadCrumbItem *breadCrumbItem = [[Y2WBreadCrumbItem alloc] init];
    breadCrumbItem.title = model.title;
    [self.breadCrumbView pushToItem:breadCrumbItem];
}



- (void)pushItem:(DataPickerItem *)item {
    if (!item.folder || !item.children) {
        return;
    }
    Y2WDataPickerViewController *dataPickerVC = [[Y2WDataPickerViewController alloc] initWithItems:item.children];
    dataPickerVC.title = item.name;
    [self pushViewController:dataPickerVC animated:YES];
    
    Y2WBreadCrumbItem *breadCrumbItem = [[Y2WBreadCrumbItem alloc] init];
    breadCrumbItem.title = item.name;
    [self.breadCrumbView pushToItem:breadCrumbItem];
}

- (void)selectItem:(DataPickerItem *)item {
    if (!item) {
        return;
    }
    self.model.selected[item.ID] = item;
    [self.pickedView pushItem:item];
    
    if (!self.model.multiple) {
        [self done];
    }
    
    [self updateDoneItem];
}

- (void)deselectItem:(DataPickerItem *)item {
    if (!item) {
        return;
    }
    [self.model.selected removeObjectForKey:item.ID];
    [self.pickedView removeItem:item];
    
    [self updateDoneItem];
}

- (BOOL)isSelectedItem:(DataPickerItem *)item {
    return !!self.model.selected[item.ID];
}




#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
    viewController.navigationItem.leftBarButtonItem = self.cancelItem;
    
    if (self.model.multiple) {
        viewController.navigationItem.rightBarButtonItem = self.doneItem;
    }
}



#pragma mark - DataPickedViewDelegate

- (void)dataPickedView:(DataPickedView *)view didSelectItem:(DataPickerItem *)item {
    [self deselectItem:item];
    [self.topViewController viewWillAppear:YES];
}



#pragma mark - Y2WBreadCrumbViewDelegate

- (void)breadCrumbView:(Y2WBreadCrumbView *)view didSelectItemAtIndex:(NSInteger)index {
    [view popToIndex:index];
    [self popToViewController:self.childViewControllers[index] animated:YES];
}






#pragma mark - Response

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done {
    if (self.handler) {
        self.handler(self.model.selected.allKeys);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateDoneItem {
    NSInteger count = [self countOfSelected];
    self.doneItem.title = [NSString stringWithFormat:@"确定(%@)",@(count)];
}



#pragma mark - Helper 

- (NSInteger)countOfSelected {
    return self.model.selected.allKeys.count;
}





- (DataPickedView *)pickedView {
    if (!_pickedView) {
        _pickedView = [[DataPickedView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)
                                                   delegate:self];
        _pickedView.avatar = self.model.avatar;
    }
    return _pickedView;
}

- (Y2WBreadCrumbView *)breadCrumbView {
    if (!_breadCrumbView) {
        CGFloat y = 64;
        if (self.model.multiple) {
            y = self.pickedView.frame.origin.y + self.pickedView.frame.size.height;
        }
        _breadCrumbView = [[Y2WBreadCrumbView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 36)
                                                          delegate:self];
    }
    return _breadCrumbView;
}

- (UIBarButtonItem *)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(cancel)];
    }
    return _cancelItem;
}

- (UIBarButtonItem *)doneItem {
    if (!_doneItem) {
        _doneItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"确定(%@)",@([self countOfSelected])]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(done)];
    }
    return _doneItem;
}

- (UIEdgeInsets)contentInset {
    if (UIEdgeInsetsEqualToEdgeInsets(_contentInset, UIEdgeInsetsZero)) {
        CGFloat y = self.breadCrumbView.frame.origin.y + self.breadCrumbView.frame.size.height;
        _contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }
    return _contentInset;
}

@end
