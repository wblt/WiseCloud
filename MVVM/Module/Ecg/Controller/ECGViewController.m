//
//  ECGViewController.m
//  HuiJianKang
//
//  Created by mac on 16/7/29.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "ECGViewController.h"

#import "HealthReportController.h"

@interface ECGViewController ()<UIWebViewDelegate>

@end

@implementation ECGViewController {
    UIWebView *webView;
}

/**
 *  心电图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"心电图";

    //添加背景图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = [UIImage imageNamed:@"register_bg"];
    [self.view addSubview:bgView];

    //创建webView
    [self creataWebView];
    
    [self createCCRButton];
    
    //加载数据
    [self loadData];

}

- (void)creataWebView {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    webView.scalesPageToFit=YES;
    webView.delegate = self;
    [self.view addSubview:webView];
}

#pragma mark - 加载数据
- (void)loadData {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *str = [NSString stringWithFormat:@"http://101.201.80.234:8080/watchclient/seeEcgDay.htm?deviceid=%@",userModel.defaultDeVice];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:str]];
    
    [webView loadRequest: request];
}

- (void)createCCRButton {
    //添加一个健康报告的按钮
    UIButton *CCRButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [CCRButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [CCRButton setTitle:@"健康报告" forState:UIControlStateNormal];
    [CCRButton addTarget:self action:@selector(CCRButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CCRButton];
    
    [CCRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.mas_offset(20);
        make.right.equalTo(self.view).with.mas_offset(-20);
        make.bottom.equalTo(self.view).with.mas_offset(-50);
    }];
}

#pragma mark - 按钮点击相应方法
- (void)CCRButtonAction:(UIButton *)sender {
    NSLog(@"按钮点击方法");
    HealthReportController *healthVC = [[HealthReportController alloc] init];
    healthVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthVC animated:YES];
}
@end
