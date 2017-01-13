//
//  LoadingPageView.m
//  videoTest
//
//  Created by duanhl on 16/10/6.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "LoadingPageView.h"

@interface LoadingPageView ()

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;     //加载图片
@property (weak, nonatomic) IBOutlet UIView      *reloadView;           //重新加载的view
@property (weak, nonatomic) IBOutlet UIImageView *reloadImageView;      //重新加载图片
@property (weak, nonatomic) IBOutlet UILabel     *reloadLabel;          //重新加载的label
@property (weak, nonatomic) id<LoadingPageDelegate> loadingDelegate;

@end

@implementation LoadingPageView

+ (LoadingPageView *)instanceLoadingPageDelegate:(nullable id)delegate
{
    NSArray *arrayView = [[NSBundle mainBundle] loadNibNamed:@"LoadingPageView" owner:nil options:nil];
    LoadingPageView *loadingPageView = [arrayView firstObject];
    loadingPageView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
    loadingPageView.loadingDelegate = delegate;
    
    return loadingPageView;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.reloadView.backgroundColor = [UIColor clearColor];
    self.reloadLabel.backgroundColor = [UIColor clearColor];
    self.reloadLabel.textColor = [UIColor lightGrayColor];
    
    self.loadingImageView.hidden = NO;
    self.reloadView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTapAction:)];
    [self.reloadView addGestureRecognizer:tap];
    
    [self setupLoadingImage];
    [self setupReloadView];
    self.loadingStatus = LoadingPageStatusLoading;
}

- (void)setLoadingStatus:(LoadingPageStatus)loadingStatus
{
    _loadingStatus = loadingStatus;
    
    switch (loadingStatus) {
        case LoadingPageStatusLoading:
        {
            self.hidden = NO;
            self.loadingImageView.hidden = NO;
            self.reloadView.hidden = YES;
            [self.loadingImageView startAnimating];
            break;
        }
        case LoadingPageStatusFinish:
        {
            self.hidden = YES;
            [self.loadingImageView stopAnimating];
            self.loadingImageView.hidden = YES;
            self.reloadView.hidden = YES;
            break;
        }
        case LoadingPageStatusFail:
        {
            [self.loadingImageView stopAnimating];
            self.hidden = NO;
            self.loadingImageView.hidden = YES;
            self.reloadView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)setupLoadingImage
{
    UIImage *image = [UIImage y2w_animatedGIFNamed:@"loading"];
//    self.loadingImageView.image = image;
    self.loadingImageView.animationImages = image.images;       //动画图片数组
    self.loadingImageView.animationDuration = image.duration;   //执行一次完整动画所需的时长
}

- (void)setupReloadView
{
    self.reloadImageView.image = [UIImage imageNamed:@"reLoadingImage"];
    self.reloadLabel.text = @"重新加载...";
}

#pragma mark 重新加载手执
- (void)reloadTapAction:(UITapGestureRecognizer *)tap
{
    self.loadingStatus = LoadingPageStatusLoading;
    
    if (self.loadingDelegate && [self.loadingDelegate respondsToSelector:@selector(loadingPageView:)]) {
        [self.loadingDelegate loadingPageView:self];
    }
}

@end
