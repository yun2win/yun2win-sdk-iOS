//
//  ScanViewController.h
//  TV
//
//  Created by yun on 15/10/16.
//  Copyright © 2015年 yun. All rights reserved.
//  扫一扫页面

#import "BaseViewController.h"

@interface ScanViewController : BaseViewController

@property (nonatomic, copy)void (^scanContactBlock)(Y2WContact *contact);            //扫描有连接人的回调

@end
