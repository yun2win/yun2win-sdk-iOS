//
//  PromptBoxView.h
//  ibama
//
//  Created by duanhongiang on 16/3/17.
//  Copyright © 2016年 ibama. All rights reserved.
//  弹框

#import <UIKit/UIKit.h>

@interface PromptBoxView : UIView

- (void)show:(void (^)())back;

@property (nonatomic, strong)NSString       *title;         //标题

@end
