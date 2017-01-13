//
//  LoginViewController.m
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "Y2WUser.h"
#import "Y2WCurrentUser.h"
#import "Y2WUsers.h"
#import "EmojiManage.h"
#import "LoginManager.h"
#import "ValidTool.h"

@interface LoginViewController ()<UITextFieldDelegate,LoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *psdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end


@implementation LoginViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self autoLogin];
}

- (IBAction)registration:(UIButton *)sender {

    RegisterViewController *re = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    re.delegate = self;
    [self.navigationController pushViewController:re animated:YES];
}

- (IBAction)login:(id)sender {
//    if (![ValidTool isValidateEmail:self.accountTextField.text]) {
//        [UIAlertView showTitle:nil message:@"请输入正确的邮箱帐号"];
//        return;
//    }
    if (self.psdTextField.text.length <= 0){
        [UIAlertView showTitle:nil message:@"请输入密码"];
        return;
    }
    
    [self loginWithAccount:self.accountTextField.text password:self.psdTextField.text];
}


- (void)loginWithAccount:(NSString *)account password:(NSString *)password {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[Y2WUsers getInstance].remote loginWithAccount:account password:password success:^(Y2WCurrentUser *currentUser) {
        [hub hideAnimated:YES];
        [[EmojiManage shareEmoji] syncEmoji];
        
        MainViewController *main = [[MainViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = main;
        
        [[LoginManager sharedManager] setAccount:account];
        [[LoginManager sharedManager] setPassword:password];
        [[LoginManager sharedManager] login];
        
    } failure:^(NSError *error) {
        hub.mode = MBProgressHUDModeText;
        hub.label.text = error.message;
        [hub hideAnimated:YES afterDelay:2];
    }];
}




- (void)autoLogin {
    self.accountTextField.text = [LoginManager sharedManager].account;
    self.psdTextField.text = [LoginManager sharedManager].password;
    if ([LoginManager sharedManager].logined) {
        [self login:nil];
    }
}


#pragma mark - TextFieldDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.accountTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
    return YES;
}

@end
