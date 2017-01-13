//
//  LoadingPageView.h
//  videoTest
//
//  Created by duanhl on 16/10/6.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingPageView;

typedef NS_ENUM(NSInteger, LoadingPageStatus) {
    LoadingPageStatusLoading,            //加载中...
    LoadingPageStatusFinish,             //加载完成
    LoadingPageStatusFail                //加载失败
};

NS_ASSUME_NONNULL_BEGIN
@protocol LoadingPageDelegate <NSObject>

//重新加载
- (void)loadingPageView:(LoadingPageView *)reloadLoadingView;

@end

@interface LoadingPageView : UIView

+ (LoadingPageView *)instanceLoadingPageDelegate:(nullable id)delegate;

@property (assign, nonatomic) LoadingPageStatus     loadingStatus;      //加载状态
NS_ASSUME_NONNULL_END
@end
