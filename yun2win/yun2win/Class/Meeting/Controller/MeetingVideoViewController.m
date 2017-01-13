//
//  MeetingVideoViewController.m
//  yunTV
//
//  Created by duanhl on 16/11/17.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "MeetingVideoViewController.h"
#import "MeetingVideoMenuView.h"

@interface MeetingVideoViewController ()

@property (weak, nonatomic)MeetingVideoMenuView     *menuView;

@end

@implementation MeetingVideoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MeetingVideoMenuView *menuView = [MeetingVideoMenuView instanceMeetingVideoMenuView];
    menuView.frame = CGRectMake(0.0f, 64.0f, SCREEN_WIDTH, 400.0f);
    menuView.userArray = @[@"我", @"张三", @"李四"];
    menuView.alpha = 0.0f;
    self.menuView = menuView;
    [self.view addSubview:menuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kNavLeft;
    [self setupGestureRecognizer];
}

- (void)setupGestureRecognizer{
    //单击
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    //双击
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(menuHiddenAction:) object:nil];
    [self performSelector:@selector(menuHiddenAction:) withObject:nil afterDelay:10.0f];
    
    [UIView animateWithDuration:.20f animations:^{
        self.menuView.alpha = 1.0f;
    }];
}

- (void)menuHiddenAction:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:.25f animations:^{
        self.menuView.alpha = 0.0f;
    }];
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    
}

@end
