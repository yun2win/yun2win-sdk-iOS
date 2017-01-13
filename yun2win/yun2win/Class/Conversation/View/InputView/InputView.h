//
//  InputView.h
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewProtocol.h"
#import "InputTextView.h"
#import "MoreInputView.h"
#import "AGEmojiKeyBoardView.h"
#import "AGEmojiPageView.h"

@interface InputView : UIView

@property (nonatomic, assign) id<InputViewUIDelegate> UIDelegate;
@property (nonatomic, assign) id<InputViewActionDelegate> ActionDelegate;
@property (nonatomic, assign) id<InputViewMoreDelegate> MoreDelegate;

@property (nonatomic, strong) UIButton *switchInputBtn;

@property (nonatomic, retain) InputTextView *textView;

/**
 *  录音键
 */
@property (nonatomic, strong) UIButton *voiceRecordBtn;

@property (nonatomic, retain) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *emojiBtn;

@property (nonatomic, retain) MoreInputView *moreInputView;

@property(nonatomic, strong) AGEmojiKeyboardView *emojiKeyboardView;
@end
