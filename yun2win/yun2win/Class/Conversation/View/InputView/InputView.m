//
//  InputView.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "InputView.h"
#import "Mp3Recorder.h"
#import "UUProgressHUD.h"

//typedef NS_ENUM(NSInteger, IntputType){
//    IntputTextView = 1,
//    IntputVoiceRecord = 2
//};

@interface InputView ()<UITextViewDelegate,AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource,Mp3RecorderDelegate>
{
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
}

@end
@implementation InputView {
    CGFloat keyBoardHeight;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)beginConvert {
    
}

- (void)endConvertWithData:(NSData *)voiceData {
    
}

- (void)failRecord {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];

        [self addSubview:self.switchInputBtn];
        [self addSubview:self.voiceRecordBtn];
        [self addSubview:self.textView];
        [self addSubview:self.moreBtn];
        [self addSubview:self.emojiBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = self.superview.width;
    self.moreBtn.right = self.width;
    self.emojiBtn.right = self.moreBtn.left +10;
    self.switchInputBtn.left = 5;
    [self layoutTextView];
    [self layoutVoiceRecordBtn];
    
    self.bottom = self.superview.height - keyBoardHeight;
}

- (void)layoutVoiceBut {
    self.voiceRecordBtn.hidden = [self needShowTextView];
    self.voiceRecordBtn.left = self.switchInputBtn.right;
    self.voiceRecordBtn.width = self.emojiBtn.left - self.voiceRecordBtn.right;
    self.voiceRecordBtn.top = 5;
    self.voiceRecordBtn.height = self.height - 10;
}


- (void)layoutTextView {

    self.textView.hidden = ![self needShowTextView];
    self.textView.left = self.switchInputBtn.right;
    self.textView.width = self.emojiBtn.left - self.textView.left;
    self.textView.top = 5;
    self.textView.height = self.height - 10;
}

- (void)layoutVoiceRecordBtn
{
    self.voiceRecordBtn.hidden = [self needShowTextView];
    self.voiceRecordBtn.left = self.switchInputBtn.right;
    self.voiceRecordBtn.width = self.emojiBtn.left - self.voiceRecordBtn.right;
    self.voiceRecordBtn.top = 5;
    self.voiceRecordBtn.height = self.height - 10;
}


#pragma mark - ———— Helper ———— -

- (BOOL)needShowTextView {
    return !self.switchInputBtn.selected;
}

#pragma mark - ———— UITextViewDelegate ———— -

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsLayout];
    self.emojiKeyboardView.sendButtonEnabled = textView.hasText;

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        if (textView.hasText && [self.ActionDelegate respondsToSelector:@selector(inputView:onSendText:)]) {
            [self.ActionDelegate inputView:self onSendText:textView.text];
        }
        return NO;
    }
    if ([self.ActionDelegate respondsToSelector:@selector(inputView:didInputText:)]) {
        [self.ActionDelegate inputView:self didInputText:text];
    }
    return YES;
}

#pragma mark - ———— AGEmojiKeyboardViewDelegate ———— -
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji
{
    [self.textView insertText:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView
{
    [self.textView deleteBackward];
}

- (void)emojiKeyBoardViewDidPressSenderBtn:(AGEmojiKeyboardView *)emojiKeyBoardView
{
    if (!self.textView.hasText) {
        return;
    }
    if ([self.ActionDelegate respondsToSelector:@selector(inputView:onSendText:)]) {
        [self.ActionDelegate inputView:self onSendText:self.textView.text];
    }
}

#pragma mark - ———— UIKeyboardNotification ———— -

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.window) return;

    [self.UIDelegate inputView:self showKeyboard:YES];

    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    keyBoardHeight = endFrame.size.height;
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.bottom = self.superview.height - keyBoardHeight;
        [self.UIDelegate inputView:self didChangeTop:self.top];

    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.UIDelegate inputView:self showKeyboard:NO];
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    keyBoardHeight = 0;
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.bottom = self.superview.height - keyBoardHeight;
        [self.UIDelegate inputView:self didChangeTop:self.top];
        
    } completion:^(BOOL finished) {
 
    }];
    
    // todo 临时处理，键盘出现时是上次的内容
    self.moreBtn.selected = NO;
    self.emojiBtn.selected = NO;
    self.textView.inputView = nil;
}


- (BOOL)endEditing:(BOOL)force {
    BOOL sForce = [super endEditing:force];
    
    if ([self.textView isFirstResponder]) {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        [self.textView resignFirstResponder];
    }
    return sForce;
}



#pragma mark - ———— Response ———— -
- (void)showVoiceRecord:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.voiceRecordBtn.hidden = !button.selected;
    [self setNeedsLayout];
    if (button.selected) {
        [self.textView resignFirstResponder];
    }else{
        [self.textView becomeFirstResponder];
    }
}

- (void)showMoreInput:(UIButton *)button {
    button.selected = !button.isSelected;
    
    self.textView.inputView = button.isSelected ? self.moreInputView : nil;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)showEmojiInput:(UIButton *)button
{
    button.selected = !button.isSelected;
    
    self.textView.inputView = button.isSelected ? self.emojiKeyboardView : nil;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

#pragma mark - ———— RecordVoice ———— -
- (void)beginRecordVoice:(UIButton *)button
{
    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
    if (playTimer) {
        if ([self.ActionDelegate respondsToSelector:@selector(inputView:onSendVoice:time:)]) {
            [self.ActionDelegate inputView:self onSendVoice:[MP3 stopRecord] time:playTime];
        }
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithSuccess:@"录音成功"];

}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"取消成功"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"松开取消发送"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"松开发送"];
}

- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

//科大讯飞，语音识别按钮
- (void)voiceButClick:(UIButton *)sender {
    if (self.ActionDelegate && [self.ActionDelegate respondsToSelector:@selector(inputView:clickVoiceButton:)]) {
        [self.ActionDelegate inputView:self clickVoiceButton:sender];
    }
}

#pragma mark - ———— setter ———— -

- (void)setMoreDelegate:(id<InputViewMoreDelegate>)MoreDelegate {
    self.moreInputView.delegate = MoreDelegate;
}




#pragma mark - ———— getter ———— -

- (InputTextView *)textView {
    if (!_textView) {
        _textView = [[InputTextView alloc] init];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

- (UIButton *)voiceRecordBtn
{
    if (!_voiceRecordBtn) {
        _voiceRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordBtn.layer.cornerRadius = 5;
        
        _voiceRecordBtn.layer.borderColor = [UIColor colorWithHexString:@"5a5a5a5"].CGColor;
        _voiceRecordBtn.layer.borderWidth = 0.5;
        _voiceRecordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_voiceRecordBtn setBackgroundImage:[UIImage imageWithUIColor:[UIColor colorWithHexString:@"c3eae7"]] forState:UIControlStateHighlighted];
        [_voiceRecordBtn setTitleColor:[UIColor colorWithHexString:@"353535"] forState:UIControlStateNormal];
        [_voiceRecordBtn setTitleColor:[UIColor colorWithHexString:@"353535"] forState:UIControlStateHighlighted];
        [_voiceRecordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceRecordBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    
        [_voiceRecordBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_voiceRecordBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceRecordBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceRecordBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchCancel];
        [_voiceRecordBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_voiceRecordBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        
    }
    return _voiceRecordBtn;
}

- (UIButton *)switchInputBtn
{
    if (!_switchInputBtn) {
        _switchInputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchInputBtn setImage:[UIImage y2w_imageNamed:@"输入框-语音输入"] forState:UIControlStateNormal];
        [_switchInputBtn setImage:[UIImage y2w_imageNamed:@"输入框-文字输入"] forState:UIControlStateSelected];
        [_switchInputBtn addTarget:self action:@selector(showVoiceRecord:) forControlEvents:1<<6];
        _switchInputBtn.width = _switchInputBtn.height = self.height;
    }
    return _switchInputBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage y2w_imageNamed:@"输入框-更多-默认"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage y2w_imageNamed:@"输入框-更多-按下"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(showMoreInput:) forControlEvents:1<<6];
        _moreBtn.width = _moreBtn.height = self.height;
    }
    return _moreBtn;
}

- (UIButton *)emojiBtn
{
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setImage:[UIImage y2w_imageNamed:@"输入框-表情输入-默认"] forState:UIControlStateNormal];
        [_emojiBtn setImage:[UIImage y2w_imageNamed:@"输入框-表情输入-按下"] forState:UIControlStateSelected];
        [_emojiBtn addTarget:self action:@selector(showEmojiInput:) forControlEvents:1<<6];
        _emojiBtn.width = _emojiBtn.height = self.height;
    }
    return _emojiBtn;
}

- (MoreInputView *)moreInputView {
    if (!_moreInputView) {
        _moreInputView = [[MoreInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 195)];
    }
    return _moreInputView;
}

- (AGEmojiKeyboardView *)emojiKeyboardView
{
    if (!_emojiKeyboardView) {
        _emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.width, 195) dataSource:self];
        _emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _emojiKeyboardView.delegate = self;
        self.textView.inputView = _emojiKeyboardView;
    }
    return _emojiKeyboardView;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage y2w_imageNamed:@"输入框-表情删除"];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [UIImage y2w_imageNamed:@"输入框-表情删除"];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    UIImage *img = [UIImage y2w_imageNamed:@"输入框-表情删除"];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}


@end
