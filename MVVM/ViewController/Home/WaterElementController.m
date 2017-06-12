//
//  WaterElementController.m
//  HuiJianKang
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "WaterElementController.h"

#import "CustomFooterBar.h"

#import "Masonry.h"

#import "ZIncomeCircle.h"

@interface WaterElementController ()
{
    ZIncomeCircle *_todayCircle;
    NSInteger _random;
}

@end

@implementation WaterElementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"水分检测";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //背景图
    [self createBgRounder];
    
    //圆环
    [self createCircle];
    
    //底部结果条
    [self createFooterBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)createBgRounder {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgView.image = [UIImage imageNamed:@"ic_theme_background"];
    [self.view addSubview:imgView];
}

- (void)createCircle {
    
    CGFloat circleWith = 200;
    CGRect circleRect = CGRectMake((kScreenWidth-circleWith)/2,120, circleWith, circleWith);
    _todayCircle = [[ZIncomeCircle alloc]initWithFrame:circleRect];
    _todayCircle.backLineColor = [UIColor whiteColor];
    _todayCircle.lineColor = [UIColor cyanColor];
    _todayCircle.isHome = YES;
    _todayCircle.headType = ZIncomeHeadTypeToday;
    [self.view addSubview:_todayCircle];
    _todayCircle.progress =  0/100.0;
    
    UILabel *waterLabel = [[UILabel alloc] init];
    waterLabel.text = @"00.0%";
    waterLabel.textColor = [UIColor whiteColor];
    waterLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:waterLabel];
    
    [waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_todayCircle);
        make.centerX.equalTo(self.view).with.offset(-10);
    }];
    
    UILabel *pctLabel = [[UILabel alloc] init];
    pctLabel.text = @"pct";
    pctLabel.font = [UIFont systemFontOfSize:14];
    pctLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:pctLabel];
    
    [pctLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(waterLabel.mas_right).with.offset(2);
        make.bottom.equalTo(waterLabel).with.offset(-7);
    }];
    
    UIImageView *waterImg = [[UIImageView alloc] init];
    waterImg.image = [UIImage imageNamed:@"ic_detect_water_icon"];
    [self.view addSubview:waterImg];
    
    [waterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pctLabel);
        make.bottom.equalTo(pctLabel.mas_top).with.offset(3);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
    }];
    
    UILabel *seachLabel = [[UILabel alloc] init];
    seachLabel.text = @"正在搜索...";
    seachLabel.font = [UIFont systemFontOfSize:14];
    seachLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:seachLabel];
    
    [seachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_todayCircle.mas_bottom).with.offset(30);
        make.centerX.equalTo(_todayCircle);
    }];

    
}

- (void)createFooterBar {
    CustomFooterBar *footerBar = [[CustomFooterBar alloc] init];
    footerBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerBar];
    [footerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-180);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"ic_detect_water_icon"];
    [self.view addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerBar);
        make.bottom.equalTo(footerBar.mas_top).with.offset(-2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(15);
    }];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.text = @"0.0%";
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:resultLabel];
    
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(3);
        make.centerY.equalTo(img);
    }];
}
@end
