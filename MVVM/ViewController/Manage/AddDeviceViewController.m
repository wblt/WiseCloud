//
//  AddDeviceViewController.m
//  HuiJianKang
//
//  Created by liuzhenhao on 16/8/25.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "AddDeviceViewController.h"

#import "XDScaningViewController.h"

@interface AddDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deviceNum;
@property (weak, nonatomic) IBOutlet UITextField *SIMNum;

@property (weak, nonatomic) IBOutlet UITextField *name;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手表设备";
}

- (IBAction)scanDeviceAction:(id)sender {
    XDScaningViewController *scanningVC = [[XDScaningViewController alloc]init];
    scanningVC.backValue = ^(NSString *scannedStr){
        self.deviceNum.text = scannedStr;
    };
    [self.navigationController pushViewController:scanningVC animated:YES];
}

- (IBAction)confirmAction:(id)sender {
    if (self.deviceNum.text.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"设备号不能为空"];
        return;
    }
    
    if (self.SIMNum.text.length == 0 || self.SIMNum.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"SIM卡号不能为空或者不足11位"];
        return;
    }
    
    if (_name.text.length == 0) {
        self.name.text = self.deviceNum.text;
    }
    
    NSString *md5Pname = [GTMBase64 stringByEncodingData:[self.name.text dataUsingEncoding:NSUTF8StringEncoding]];
    
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    
    NSString *urlStr = [NSString stringWithFormat:@"hjkBindingEI.htm?phone=%@&deviceid=%@&nikename=%@&phonenumber%@",userModel.userPhoneNum,self.deviceNum.text,md5Pname,self.SIMNum.text];
    [NetRequestClass requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        NSInteger num = [data integerValue];
        if (num == 0) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"绑定失败"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
@end
