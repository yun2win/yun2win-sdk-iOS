//
//  UUProgressHUD.m
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"

@interface UUProgressHUD ()
{
    NSTimer *myTimer;
    int angle;
    
//    UILabel *centerLabel;
    UIImageView *centerImageView;
//    UIImageView *edgeImageView;
    
}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation UUProgressHUD

@synthesize overlayWindow;

+ (UUProgressHUD*)sharedView {
    static dispatch_once_t once;
    static UUProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    });
    return sharedView;
}

+ (void)show {
    [[UUProgressHUD sharedView] show];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
//        if (!centerLabel){
//            centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
//            centerLabel.backgroundColor = [UIColor clearColor];
//        }
        
        if (!centerImageView) {
            centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 168, 168)];
        }
        
//        if (!self.subTitleLabel){
//            self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
//            self.subTitleLabel.backgroundColor = [UIColor clearColor];
//        }
//        if (!self.titleLabel){
//            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
//            self.titleLabel.backgroundColor = [UIColor clearColor];
//        }
//        if (!edgeImageView)
//            edgeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"语音录入动画图"]];
        
//        self.subTitleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 + 30);
//        self.subTitleLabel.text = @"松开发送";
//        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
//        self.subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
//        self.subTitleLabel.textColor = [UIColor whiteColor];
        
//        self.titleLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 - 30);
//        self.titleLabel.text = @"Time Limit";
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        self.titleLabel.textColor = [UIColor whiteColor];
        
//        centerLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
//        centerLabel.text = @"60";
//        centerLabel.textAlignment = NSTextAlignmentCenter;
//        centerLabel.font = [UIFont systemFontOfSize:30];
//        centerLabel.textColor = [UIColor yellowColor];

//        centerImageView.image = [UIImage imageNamed:@"录制语音-0"];
        centerImageView.highlightedImage = [UIImage y2w_imageNamed:@"录音取消发送"];
        centerImageView.animationImages = @[[UIImage y2w_imageNamed:@"录制语音-0"],
                                            [UIImage y2w_imageNamed:@"录制语音-1"],
                                            [UIImage y2w_imageNamed:@"录制语音-2"],
                                            [UIImage y2w_imageNamed:@"录制语音-3"],
                                            [UIImage y2w_imageNamed:@"录制语音-4"],
                                            [UIImage y2w_imageNamed:@"录制语音-5"],
                                            [UIImage y2w_imageNamed:@"录制语音-6"]];
        centerImageView.highlighted = NO;
        centerImageView.animationDuration = 1;
        centerImageView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
        
//        edgeImageView.frame = CGRectMake(0, 0, 154, 154);
//        edgeImageView.center = centerLabel.center;
//        [self addSubview:edgeImageView];
//        [self addSubview:centerLabel];
        [self addSubview:centerImageView];
//        [self addSubview:self.subTitleLabel];
//        [self addSubview:self.titleLabel];

        if (myTimer)
            [myTimer invalidate];
        myTimer = nil;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(startAnimation)
                                                 userInfo:nil
                                                  repeats:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
    });
}
-(void) startAnimation
{
    angle -= 3;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    [centerImageView startAnimating];
    [UIView commitAnimations];
}

+ (void)changeSubTitle:(NSString *)str
{
    [[UUProgressHUD sharedView] setState:str];
}

- (void)setState:(NSString *)str
{
//    self.subTitleLabel.text = str;
    if ([str isEqualToString:@"松开取消发送"]) {
        centerImageView.highlighted = YES;
    }
}

+ (void)dismissWithSuccess:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [myTimer invalidate];
        myTimer = nil;
        //        self.subTitleLabel.text = nil;
        //        self.titleLabel.text = nil;
        //        centerLabel.text = state;
        //        centerLabel.textColor = [UIColor whiteColor];
        
        CGFloat timeLonger;
        if ([state isEqualToString:@"TooShort"]) {
            timeLonger = 1;
        }else{
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [centerImageView removeFromSuperview];
                                 centerImageView.image = nil;
                                 [self.subTitleLabel removeFromSuperview];
                                 self.subTitleLabel = nil;
                                 
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}


@end
