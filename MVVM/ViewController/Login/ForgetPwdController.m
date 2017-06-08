//
//  ForgetPwdController.m
//  HJKHiWatch
//
//  Created by AirTops on 15/11/27.
//  Copyright © 2015年 cn.hi-watch. All rights reserved.
//

#import "ForgetPwdController.h"
#import "NetworkSingleton.h"
#import "UserConfig.h"
#import "NSString+MD5.h"


@interface ForgetPwdController ()

@property (assign, nonatomic) BOOL presenting;

@end

@implementation ForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码找回";
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
     [_phoneNum addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

// textField 长度限制
- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField == _phoneNum) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.presenting = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.presenting = NO;
}

#pragma mark - 获取验证码
- (IBAction)getSmsCodeAction:(id)sender {
    NSString *phoneNumber = [self.phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNumber checkPhoneNumInput]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"sendCode.htm?phone=%@&autograph=5oOg5YGl5bq3%%0A",phoneNumber];
    [NetworkSingleton requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送,请稍后"];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败，请检测网络"];
    }];
    [self countTimer];
}


#pragma mark - 提交
- (IBAction)forgotPasswordAction:(id)sender {
    NSString *phoneNumber = [self.phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNumber checkPhoneNumInput]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSString *md5Pass = [NSString md5_Encrypt:self.passwordFiled.text];
    if ([self.smsCodeFiled.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证码不为空"];
        return;
    }
    if ([self.passwordFiled.text length] < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码不少于6位"];
        return;
    }
    
    if ([self.certainPassword.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    
    if (![self.certainPassword.text isEqualToString:self.passwordFiled.text]) {
        [SVProgressHUD showErrorWithStatus:@"确认密码不一致"];
        return;
    }
    
    [SVProgressHUD showErrorWithStatus:@"修改中..."];
    
    NSString *urlStr = [NSString stringWithFormat:@"setNewPwd.htm?phone=%@&idCode=%@&password=%@",phoneNumber,self.smsCodeFiled.text,md5Pass];
    [NetworkSingleton requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        [SVProgressHUD dismiss];
        NSInteger result = [data integerValue];
        if (result == 0) {
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userPhoneNum = phoneNumber;
            userModel.userPassword = self.passwordFiled.text;
            userModel.userName = @"无";
            [[UserConfig shareInstace] setAllInformation:userModel];
            //注册成功，跳转到登陆页码
            if (self.forgetBackBlock) {
                self.forgetBackBlock(phoneNumber,self.passwordFiled.text);
            }
            [self showSuccess:@"修改成功"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.5];
            
        }
        else if (result == 1) {
            [self showError:@"修改失败"];
        }
        
    } failureBlock:^(NSError *error) {
        [self hideHud];
        [self showError:@"修改失败,请检测网络"];
    }];
}

- (void)countTimer {
    //4.60s计时
    self.smsCodeBtn.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        int counter = 60;
        while (--counter >= 0 && _presenting) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.smsCodeBtn setTitle: [NSString stringWithFormat:@"%d秒", counter + 1] forState: UIControlStateDisabled];
            });
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.smsCodeBtn.enabled = YES;
        });
    });
}

@end
