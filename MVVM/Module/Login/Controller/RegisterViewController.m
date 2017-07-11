//
//  RegisterViewController.m
//  HJKHiWatch
//
//  Created by AirTops on 15/11/27.
//  Copyright © 2015年 cn.hi-watch. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController ()
@property (assign, nonatomic) BOOL presenting;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册新用户";
    
    //去掉导航栏黑线
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
    [_userNameFiled addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

// textField 长度限制
- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField == _userNameFiled) {
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
    NSString *phoneNumber = [self.userNameFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNumber checkPhoneNumInput]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *base64Name = [[GTMBase64 encodeBase64String:@"智能云健康"] stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    NSString *urlStr = [NSString stringWithFormat:@"sendCode.htm?phone=%@&autograph=%@",self.userNameFiled.text,base64Name];
    [self countTimer];
   [NetRequestClass native_requestURL:urlStr httpMethod:@"GET" params:nil successBlock:^(id returnValue) {
        [SVProgressHUD showErrorWithStatus:@"验证码已发送,请稍后"];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败，请检测网络"];
    }];
}

#pragma mark - 注册
- (IBAction)registerAction:(id)sender {
    NSString *phoneNumber = [self.userNameFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNumber checkPhoneNumInput]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSString *md5Pass = [NSString md5_Encrypt:self.passwordFiled.text];
    NSString *urlStr = [NSString stringWithFormat: @"regmembers.htm?username=%@&idCode=%@&password=%@",phoneNumber,self.smsCodeFiled.text,md5Pass];
    if ([self.smsCodeFiled.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
        return;
    }
    if ([self.passwordFiled.text length] < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码至少为6位"];
        return;
    }
    if ([self.rePasswordFiled.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    if (![self.rePasswordFiled.text isEqualToString:self.passwordFiled.text]) {
        [SVProgressHUD showErrorWithStatus:@"确认密码不一致"];
        return;
    }
    [SVProgressHUD showWithStatus:@"注册中..."];
    [NetRequestClass afn_requestURL:urlStr httpMethod:@"GET" params:nil  successBlock:^(id returnValue) {
        [SVProgressHUD dismiss];
        NSInteger result = [returnValue integerValue];
        if (result == 0) {
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userPhoneNum = phoneNumber;
            userModel.userPassword = self.passwordFiled.text;
            userModel.userName = @"无";
            [[UserConfig shareInstace] setAllInformation:userModel];
            
            // 设置登录状态
            [[UserConfig shareInstace] setLoginStatus:YES];
            
            //注册成功，跳转到登陆页码
            if (self.registerBackBlock) {
                self.registerBackBlock(phoneNumber,self.passwordFiled.text);
            }
            [SVProgressHUD showErrorWithStatus:@"注册成功"];
        }
        else if (result == 1) {
            [SVProgressHUD showErrorWithStatus:@"参数不完整"];
        }else if (result == 3) {
            [SVProgressHUD showErrorWithStatus:@"已经注册"];
        }else if (result == 4) {
            [SVProgressHUD showErrorWithStatus:@"验证码失败"];
        }
    } failureBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
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

- (IBAction)toBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
