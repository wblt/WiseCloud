//
//  DNADetectController.m
//  HuiJianKang
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "DNADetectController.h"

#import "CFPopView.h"

#import "CFFuncModel.h"


@interface DNADetectController ()<UIWebViewDelegate>
@property (nonatomic, strong) CFPopView *popView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *rightBtn;


@end

@implementation DNADetectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *dictArr = @[@{@"title":@"个人", @"iconName":@"数字-0.png"},@{@"title":@"中国老年人三大高危肿瘤风险预警基因检测(A1)", @"iconName":@"数字-1.png"},@{@"title":@"人体内循环风险排查及老年痴呆风险评估(A2)", @"iconName":@"数字-2.png"},@{@"title":@"二代高通量全基因肿瘤排查基因检测申请单", @"iconName":@"数字-3.png"}, @{@"title":@"个性化安全用药指导系列(D)", @"iconName":@"数字-4.png"},@{@"title":@"儿童基因检测(C1)", @"iconName":@"数字-4.png"},@{@"title":@"健康无忧系列疾病易感基因检测(B)", @"iconName":@"数字-4.png"},@{@"title":@"儿童基因检测(C2)", @"iconName":@"数字-4.png"},@{@"title":@"查看申请项目", @"iconName":@"数字-4.png"}];
    
    self.popView = [CFPopView popViewWithFuncDicts:dictArr];
    
    __weak typeof (self) weakSelf = self;
    
    self.popView.myFuncBlock = ^(NSInteger index){
        NSLog(@"%ld", (long)index);
        
        NSString *strUrl;
        
        if (index == 0) {
            UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/guser.htm?unumber=%@",userModel.userPhoneNum];
        }
        else if (index == 1) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=1"];
        }
        else if (index == 2) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=5"];
        }
        else if (index == 3) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=2"];
        }
        else if (index == 4) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=3"];
        }
        else if (index == 5) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=4"];
        }
        else if (index == 6) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=6"];
        }
        else if (index == 7) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/send.htm?type=7"];
        }
        else if (index == 8) {
            strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/check.htm"];
        }
        [weakSelf requestData:strUrl];
        weakSelf.rightBtn.selected = NO;
        [weakSelf.popView dismissFromKeyWindow];
    };
    
    //设置左侧按钮
    [self createLeftNavButton];
    
    //添加web
    [self.view addSubview:self.webView];
    
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *strUrl = [NSString stringWithFormat:@"http://101.201.80.234:8090/platform/gene/guser.htm?unumber=%@",userModel.userPhoneNum];
    [self requestData:strUrl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.popView.isShow) {
        return;
    }
    [self.popView dismissFromKeyWindow];
}

#pragma mark - 加载网站
- (void)requestData:(NSString *)str {
    //1.有网址的加载方式
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)createLeftNavButton {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


- (void)rightBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (self.popView.isShow) {
            return;
        }
        [self.popView showInKeyWindow];
    }
    else {
        if (!self.popView.isShow) {
            return;
        }
        [self.popView dismissFromKeyWindow];
        
    }
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit=YES;
        _webView.delegate = self;
    }
    return _webView;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_rightBtn setImage:[UIImage imageNamed:@"ic_drawer"] forState:UIControlStateNormal];
        
        [_rightBtn setImage:[UIImage imageNamed:@"ic_drawer"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
