//
//  InputTextView.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

- (void)dealloc {
    _placeHolder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}



- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
        self.contentInset = UIEdgeInsetsZero;
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.font = [UIFont systemFontOfSize:14.0f];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.keyboardAppearance = UIKeyboardAppearanceDefault;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeySend;
        self.textAlignment = NSTextAlignmentLeft;
        self.enablesReturnKeyAutomatically = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}



#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.0f,
                                            7.0f,
                                            rect.size.width,
                                            rect.size.height);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : [UIColor grayColor],
                                        NSParagraphStyleAttributeName : paragraphStyle }];
    }
}




- (void)didChangeNotification:(NSNotification *)noti {
//    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}



- (void)clearText {
    while (self.hasText) {
        [self deleteBackward];
    }
}



#pragma mark - ———— setter ———— -

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

@end
