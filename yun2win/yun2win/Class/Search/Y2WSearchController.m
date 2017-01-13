//
//  Y2WSearchController.m
//  API
//
//  Created by QS on 16/8/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WSearchController.h"
#import "Y2WConversationResultController.h"

@interface Y2WSearchController ()

@property (nonatomic, weak) Y2WConversationResultController *conversationRC;

@property (nonatomic, weak) UIButton    *voiceBut;

@end


@implementation Y2WSearchController

- (instancetype)init {
    Y2WConversationResultController *conversationRC = [[Y2WConversationResultController alloc] init];
    if (self = [super initWithSearchResultsController:conversationRC]) {
        self.searchBar.frame = CGRectMake(0, 0, self.view.width, 40);
        self.searchBar.barTintColor = [UIColor whiteColor];
        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        
        if ([self.searchBar respondsToSelector:@selector(searchField)]) {
            self.searchBar.searchField.layer.cornerRadius = 14;
            self.searchBar.searchField.layer.borderWidth = 0.5;
            self.searchBar.searchField.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
        }
    
        self.searchBar.searchField.clearButtonMode = UITextFieldViewModeNever;
        self.conversationRC = conversationRC;
        self.searchResultsUpdater = conversationRC;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.voiceBut.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    }];
}

@end
