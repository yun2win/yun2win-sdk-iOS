//
//  InputTextView.h
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextView : UITextView

@property (nonatomic, strong) NSString *placeHolder;

- (void)clearText;

@end
