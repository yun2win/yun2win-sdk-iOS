//
//  WebViewController.m
//  API
//
//  Created by QS on 16/8/18.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *webView;

@property (nonatomic, copy) NSString *url;

@end

@implementation WebViewController

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_返回"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
    [self.navigationItem startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}




#pragma mark - respond

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.navigationItem stopAnimating];
    self.title = webView.title;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.navigationItem stopAnimating];
    [UIAlertView showTitle:nil message:error.message];
}


#pragma mark - getter

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.clipsToBounds = YES;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
