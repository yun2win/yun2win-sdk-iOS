//
//  MoreInputView.h
//  API
//
//  Created by QS on 16/3/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewProtocol.h"

@interface MoreInputView : UIView

@property (nonatomic, retain) NSArray *items;

@property (nonatomic, assign) id<InputViewMoreDelegate>delegate;

@end
