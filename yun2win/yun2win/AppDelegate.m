//
//  AppDelegate.m
//  yun2win
//
//  Created by ShingHo on 15/12/29.
//  Copyright © 2015年 yun2win. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "DataMigration.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DataMigration migrate];
    [[ThemeManager sharedManager] defaultTheme];
    [self setMainViewController];    
    return YES;
}

- (void)setMainViewController {
    LoginViewController *login = [[LoginViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
}

- (void)openFileWithURL:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    if (!self.window.rootViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openFileWithURL:url];
        });
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *path = [NSString tempPathForKey:url.lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:url.path toPath:path error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DocumentItem *item = [[DocumentItem alloc] initWithURL:[NSURL fileURLWithPath:path] title:url.lastPathComponent];
            DocumentViewController *documentVC = [[DocumentViewController alloc] initWithItems:@[item] currentItem:item];
            [self.window.rootViewController presentViewController:documentVC animated:YES completion:nil];
        });
    });
}

#pragma mark - UIApplicationDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Y2WIMClientConfig setDeviceToken:deviceToken];
}



- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end
