//
//  MainViewController.m
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MainViewController.h"
#import "ConversationListViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "Y2WUserConversations.h"

@interface MainViewController ()<Y2WIMBridgeDelegate, Y2WUserConversationsDelegate>

@property (nonatomic, retain) Y2WUserConversations  *userConversations;

@property (nonatomic, retain) UIView *statusView;

@end

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"  //未读数

@implementation MainViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUpSubNav];
    }
    return self;
}

- (Y2WUserConversations *)userConversations {
    if (!_userConversations) {
        _userConversations = [Y2WUsers getInstance].getCurrentUser.userConversations;
    }
    return _userConversations;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[Y2WUsers getInstance].getCurrentUser.bridge addDelegate:self];
    [self.userConversations addDelegate:self];
}


- (void)setUpSubNav{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item = obj;
        NSString * vcName = item[TabbarVC];
        NSString * title  = item[TabbarTitle];
        NSString * imageName = item[TabbarImage];
        NSString * imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController * vc = [[clazz alloc] init];
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_logo"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:nil
                                                                              action:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage y2w_imageNamed:imageName]
                                               selectedImage:[UIImage y2w_imageNamed:imageSelected]];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        NSString *badgeStr = (badge > 99) ? @"99+" : [NSString stringWithFormat:@"%zd",badge];
        nav.tabBarItem.badgeValue = (badge > 0) ? badgeStr : nil;

        [array addObject:nav];
    }];
    self.viewControllers = array;
}

- (NSArray*)tabbars{

    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@{TabbarVC             : @"ConversationListViewController",
                       TabbarTitle          : @"交流",
                       TabbarImage          : @"交流-默认",
                       TabbarSelectedImage  : @"交流-选中",
                       TabbarItemBadgeValue : @(0)}];
    
    [items addObject:@{TabbarVC             : @"ContactsViewController",
                       TabbarTitle          : @"通讯录",
                       TabbarImage          : @"通讯录-默认",
                       TabbarSelectedImage  : @"通讯录-选中",
                       TabbarItemBadgeValue : @(0)}];

    
    [items addObject:@{TabbarVC             : @"SettingViewController",
                       TabbarTitle          : @"设置",
                       TabbarImage          : @"设置-默认",
                       TabbarSelectedImage  : @"设置-选中",
                       TabbarItemBadgeValue : @(0)}];
    return items;
}

#pragma mark - ———— Y2WUserConversationsDelegate ———— -
- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations {
    NSArray *converArray = [userConversations getUserConversations];
    NSInteger num = 0;
    
    for (Y2WUserConversation *tempConver in converArray) {
        num += tempConver.unRead;
    }
    
    for (UINavigationController *tempNav in self.viewControllers) {
        if ([tempNav.tabBarItem.title isEqualToString:@"交流"]) {
            NSString *badgeStr = (num > 99) ? @"99+" : [NSString stringWithFormat:@"%zd",num];
            tempNav.tabBarItem.badgeValue = (num > 0) ? badgeStr : nil;
        }
        
        break;
    }
}


#pragma mark - Y2WIMBridgeDelegate

- (void)bridge:(Y2WIMBridge *)bridge didLogoutWithMessage:(NSString *)message {
    [[LoginManager sharedManager] logout];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView transitionWithView:keyWindow duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];

    } completion:^(BOOL finished) {
        if (finished && message) {
            [UIAlertView showTitle:@"警告" message:message];
        }
    }];
}

//在线状态发生改变
- (void)bridge:(Y2WIMBridge *)bridge didChangeOnlineStatus:(BOOL)isOnline {
    if (self.statusView.hidden == isOnline) {
        return;
    }
    self.statusView.hidden = isOnline;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = [UIScreen mainScreen].bounds;
        CGFloat viewHeight = self.statusView.height * !self.statusView.isHidden;
        frame.origin.y = viewHeight;
        frame.size.height = [UIScreen mainScreen].bounds.size.height - viewHeight;
        self.view.frame = frame;
        
        CGRect statusViewFrame = self.statusView.frame;
        statusViewFrame.origin.y = -1 * self.statusView.height * isOnline;
        self.statusView.frame = statusViewFrame;
        
    } completion:^(BOOL finished) {
        NSInteger index = self.selectedIndex;
        self.selectedIndex = [self getRandomIndex];
        self.selectedIndex = index;
    }];
}

- (NSInteger)getRandomIndex {
    NSInteger index = arc4random_uniform((uint32_t)self.viewControllers.count);
    if (index == self.selectedIndex) {
        return [self getRandomIndex];
    }
    return index;
}

- (UIView *)statusView {
    if (!_statusView) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height + 20;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, - height, self.view.frame.size.width, height)];
        view.backgroundColor = [UIColor y2w_redColor];
        view.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, view.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网络连接断开,请检查网络";
        label.font = [UIFont systemFontOfSize:11];
        [view addSubview:label];
        
        _statusView = view;
    }
    return _statusView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[Y2WUsers getInstance].getCurrentUser.bridge removeDelegate:self];
    [self.userConversations removeDelegate:self];
}

@end
