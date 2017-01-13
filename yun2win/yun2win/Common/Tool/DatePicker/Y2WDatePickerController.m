//
//  Y2WDatePickerController.m
//  API
//
//  Created by QS on 16/9/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WDatePickerController.h"

@interface Y2WDatePickerController ()

@property (nonatomic, copy) void (^handler)(NSDate *date);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (nonatomic, retain) NSDate *date;

@property (nonatomic, assign) UIDatePickerMode mode;

@end


@implementation Y2WDatePickerController

- (instancetype)initWithDate:(NSDate *)date mode:(UIDatePickerMode)mode handler:(void (^)(NSDate *date))handler {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
        self.handler = handler;
        self.date = date;
        self.mode = mode;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.datePicker setDate:self.date animated:YES];
    self.datePicker.datePickerMode = self.mode;
    self.datePicker.subviews.firstObject.backgroundColor = [UIColor whiteColor];

    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottom.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}



#pragma mark - Response

- (IBAction)done:(id)sender {
    if (self.handler) {
        self.handler(self.datePicker.date);
    }
    [self dismiss];
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)dismiss {
    self.bottom.constant = -216;
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
