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
   
    UIImageView *img  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    img.image = [UIImage imageNamed:@"helpImg"];
    [self.view addSubview:img];
}
@end
