//
//  Y2WDatePickerController.h
//  API
//
//  Created by QS on 16/9/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Y2WDatePickerController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (instancetype)initWithDate:(NSDate *)date mode:(UIDatePickerMode)mode handler:(void (^)(NSDate *date))handler;

@end
