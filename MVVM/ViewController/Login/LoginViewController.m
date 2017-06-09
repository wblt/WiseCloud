//
//  LoginViewController.m
//  HJKHiWatch
//
//  Created by AirTops on 15/11/27.
//  Copyright © 2015年 cn.hi-watch. All rights reserved.
//

#import "LoginViewController.h"
//#import "UserConfig.h"
//#import "NetworkSingleton.h"
//#import "NSString+MD5.h"
//#import "HomeViewController.h"
//#import "RegisterViewController.h"
//#import "HomeViewController.h"
//#import "ForgetPwdController.h"
//#import "AppDelegate.h"
//#import "BaseNavigationController.h"
//#import "MyDeviceModel.h"
//#import "JPUSHService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_phoneNumFiled addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
//    //设置数据
//    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
//    self.phoneNumFiled.text = userModel.userPhoneNum;
//    self.passwordFiled.text = userModel.userPassword;
}

//- (void)createViewModel {
//    PublicWeiboViewModel *publicViewModel = [[PublicWeiboViewModel alloc] init];
//    [publicViewModel setBlockWithReturnBlock:^(id returnValue) {
//        [SVProgressHUD dismiss];
//        _publicModelArray = returnValue;
//        [self.tableView reloadData];
//        DDLog(@"%@",_publicModelArray);
//    } WithErrorBlock:^(id errorCode) {
//        [SVProgressHUD dismiss];
//    } WithFailureBlock:^{
//        [SVProgressHUD dismiss];
//    }];
//    
//    [publicViewModel fetchPublicWeiBo];
//    [SVProgressHUD showWithStatus:@"正在获取用户信息……" maskType:SVProgressHUDMaskTypeBlack];
//}
//
//// textField 长度限制
//- (void)textFieldDidChanged:(UITextField *)textField
//{
//    if (textField == _phoneNumFiled) {
//        if (textField.text.length > 11) {
//            textField.text = [textField.text substringToIndex:11];
//        }
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    //设置数据
////    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
////    self.phoneNumFiled.text = userModel.userPhoneNum;
////    self.passwordFiled.text = userModel.userPassword;
//}
//
//#pragma mark - 登陆
//- (IBAction)loginAction:(id)sender {
//    NSString *phoneNumber = [self.phoneNumFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (![phoneNumber checkPhoneNumInput]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
//        return;
//    }
//    if ([self.passwordFiled.text length] == 0) {
//        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
//        return;
//    }
//    NSString *md5Pass = [NSString md5_Encrypt:self.passwordFiled.text];
//    NSString *urlStr = [NSString stringWithFormat:@"logmembers.htm?username=%@&password=%@",phoneNumber,md5Pass];
//    [SVProgressHUD showWithStatus:@"登录中..."];
//    [NetworkSingleton requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
//        [SVProgressHUD dismiss];
//        //创建用户模型对象
//        NSInteger num = [data integerValue];
//        if (num == 0) {
//            UserModel *userModel = [kUserConfig getAllInformation];
//            if (userModel == nil) {
//                userModel = [[UserModel alloc] init];
//            }
//            userModel.userPhoneNum = self.phoneNumFiled.text;
//            userModel.userPassword = self.passwordFiled.text;
//            userModel.userName = @"无";
//            [[UserConfig shareInstace] setAllInformation:userModel];
//            //登陆成功，跳转至首页
//            UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//            BaseNavigationController *homeNav = [storyboad instantiateInitialViewController];
//            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            delegate.window.rootViewController = homeNav;
//            
//            //显示动画
//            delegate.window.rootViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
//            [UIView animateWithDuration:0.4 animations:^{
//                delegate.window.rootViewController.view.transform = CGAffineTransformIdentity;
//            }completion:nil];
//            
//            //登陆朋友圈
////            [self loginArrowNock];
//            
//            //这里来添加一个请求设备的列表
//            [self getDeviceList];
//            
//            NSSet *set = [NSSet setWithObject:userModel.userPhoneNum];
//            
//            /**<设置JPush别名*/
//            [JPUSHService setTags:set alias:userModel.userPhoneNum fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                NSLog(@"%d----%@---",iResCode,iAlias);
//            }];
//            
//        }
//        else if (num == -1) {
//            //弹出提示框提示
//            [SVProgressHUD showErrorWithStatus:@"请与服务公司联系,确认开通情况,联系天电话：0451-87392339"];
//        }
//        else if (num == 1) {
//            [SVProgressHUD showErrorWithStatus:@"登陆失败"];
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:@"参数错误"];
//        }
//    } failureBlock:^(NSError *error) {
//        [self hideHud];
//        [SVProgressHUD showErrorWithStatus:@"登陆失败,请检测账号和密码"];
//    }];
//}
//
//#pragma mark - 监听故事版跳转
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[RegisterViewController class]]) {
//        RegisterViewController *registerVC = (RegisterViewController *)segue.destinationViewController;
//        registerVC.registerBackBlock = ^(NSString *userName,NSString *userPassword) {
//            self.phoneNumFiled.text = userName;
//            self.passwordFiled.text = userPassword;
//        };
//    }
//    else if ([segue.destinationViewController isKindOfClass:[ForgetPwdController class]]) {
//        ForgetPwdController *forGetVC = (ForgetPwdController *)segue.destinationViewController;
//        forGetVC.forgetBackBlock = ^(NSString *userName,NSString *userPassword) {
//            self.phoneNumFiled.text = userName;
//            self.passwordFiled.text = userPassword;
//        };
//    }
//}
//
//- (void)getDeviceList {
//    UserModel *userModel = [kUserConfig getAllInformation];
//    NSString *urlStr = [NSString stringWithFormat:@"hjkSeeBinding.htm?phone=%@",userModel.userPhoneNum];
//    [NetworkSingleton requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
//        NSLog(@"%@",data);
//        NSArray *dataArray = (NSArray *)data;
//        NSMutableArray *temp = [NSMutableArray array];
//        for (int i = 0; i < dataArray.count; i++) {
//            MyDeviceModel *model = [MyDeviceModel objectWithKeyValues:dataArray[i]];
//            [temp addObject:model];
//        }
//        
//        userModel.deviceArray = [temp copy];
//        
//        if (userModel.defaultDeVice.length == 0) {
//            MyDeviceModel *tempModel = [userModel.deviceArray firstObject];
//            userModel.defaultDeVice = tempModel.deviceid;
//        }
//        
//        //保存
//        [kUserConfig setAllInformation:userModel];
//    
//    } failureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//}

@end
