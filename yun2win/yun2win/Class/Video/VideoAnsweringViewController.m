//
//  VideoAnsweringViewController.m
//  yun2win
//
//  Created by duanhl on 16/9/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "VideoAnsweringViewController.h"

@interface VideoAnsweringViewController ()
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation VideoAnsweringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
//    NSString *avatarUrl = [Y2WUsers getInstance].getCurrentUser.avatarUrl;
    self.headImageView.image = [UIImage y2w_imageNamed:@"11"];
    self.nickNameLabel.text = @"小小";
}

- (void)setupUI {
    //    NSString *actionStr = [message objectForKey:@"av"];
    //    NSString *channelStr = [message objectForKey:@"channel"];
    //    NSString *modelStr = [message objectForKey:@"mode"];
    //    NSString *senderStr = [message objectForKey:@"sender"];
    //    NSString *typeStr = [message objectForKey:@"type"];
    //    NSArray  *membersArray = [message objectForKey:@"members"];



}

#pragma mark 按钮点击事件
//挂断
- (IBAction)rejectionAction:(UIButton *)sender {
    
}

//接听
- (IBAction)answerAction:(UIButton *)sender {
    
}

@end
