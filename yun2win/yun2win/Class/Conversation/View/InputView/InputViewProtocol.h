//
//  InputViewProtocol.h
//  API
//
//  Created by QS on 16/3/15.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MoreItem.h"

@class InputView;
@protocol InputViewUIDelegate <NSObject>

- (void)inputView:(InputView *)inputView didChangeTop:(CGFloat)top;
- (void)inputView:(InputView *)inputView showKeyboard:(CGFloat)show;

@end

@protocol InputViewActionDelegate <NSObject>

- (void)inputView:(InputView *)inputView didInputText:(NSString *)text;

- (void)inputView:(InputView *)inputView onSendText:(NSString *)text;

- (void)inputView:(InputView *)inputView onSendVoice:(NSString *)voicePath time:(NSInteger)timer;

//科大讯飞，语音识别按钮
- (void)inputView:(InputView *)inputView clickVoiceButton:(UIButton *)sender;

@end

@protocol InputViewMoreDelegate <NSObject>

- (void)moreInputViewDidSelectItem:(MoreItem *)item;

@end
