//
//  BaseNavigationController.m
//  Weibo
//
//  Created by mac on 15/9/6.
//  Copyright (c) 2015年 wb. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置导航栏
    //[self _setNav];
}

/**
 *  设置导航栏
 */
- (void)_setNav {
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"";
    //[backbutton setBackButtonBackgroundImage:[UIImage imageNamed:@"info03_1_nav_return"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    self.navigationItem.backBarButtonItem = backbutton;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
}

@end
