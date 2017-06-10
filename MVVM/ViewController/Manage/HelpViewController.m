//
//  HelpViewController.m
//  HuiJianKang
//
//  Created by 冷婷 on 16/5/29.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助";
   
    UIWebView *webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.scalesPageToFit=YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *strUrl = @"http://101.201.80.234:8090/platform/gene/help.htm";
    //1.有网址的加载方式
    NSURL *url=[NSURL URLWithString:strUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end
