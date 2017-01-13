//
//  RegisterViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "RegisterViewController.h"
#import "HttpRequest.h"
#import "URL.h"
#import "ValidTool.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *psdTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ok:(id)sender {
    if (![ValidTool isValidateEmail:self.accountTextField.text])
    {
        [UIAlertView showTitle:nil message:@"请输入正确的邮箱帐号"];
        return;
    }
    if (!(self.accountTextField.text.length > 0 && self.accountTextField.text.length < 21)){
        [UIAlertView showTitle:nil message:@"请输入邮箱帐号，不超过20位字符"];
        return;
    }
    if (!(self.nickNameTextField.text.length > 0 && self.nickNameTextField.text.length < 11)){
        [UIAlertView showTitle:nil message:@"请输入昵称，不超过10位字符"];
        return;
    }
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.psdTextField.text];
    if (!isMatch){
        [UIAlertView showTitle:nil message:@"请输入6-20位字母或数字"];
        return;
    }
    
    [[Y2WUsers getInstance].remote registerWithAccount:self.accountTextField.text
                                              password:self.psdTextField.text
                                                  name:self.nickNameTextField.text
                                               success:^{
                                                   
                                                   if ([self.delegate respondsToSelector:@selector(loginWithAccount:password:)]) {
                                                       [self.delegate loginWithAccount:self.accountTextField.text
                                                                              password:self.psdTextField.text];
                                                   }

                                             } failure:^(NSError *error) {
                                                 [UIAlertView showTitle:nil message:error.message];
                                             }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
