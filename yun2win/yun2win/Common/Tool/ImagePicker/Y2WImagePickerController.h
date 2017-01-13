//
//  Y2WImagePickerController.h
//  API
//
//  Created by QS on 16/8/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Y2WImagePickerController : UIImagePickerController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

+ (instancetype)pickerWithType:(UIImagePickerControllerSourceType)type handler:(void(^)(UIImage *image))handler;

+ (instancetype)videoPickerWithMaximumDuration:(NSTimeInterval)duration handler:(void(^)(NSString *path, UIImage *image))handler;

@end
