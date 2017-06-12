//
//  DiscoverViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hi-watch.com.cn/hiwatchclient/discover.htm"]];
    [self.webView loadRequest:request];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
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
