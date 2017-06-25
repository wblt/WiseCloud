//
//  ShouhuanViewController.m
//  MVVM
//
//  Created by 冷婷 on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ShouhuanViewController.h"
#import "BLEManager.h"

@interface ShouhuanViewController ()<BLEManagerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourX;
@property (nonatomic,strong) BLEManager *ble;

@end

@implementation ShouhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.width.constant = kScreenWidth*4;
    self.secondX.constant = kScreenWidth;
    self.thridX.constant = kScreenWidth*2;
    self.fourX.constant = kScreenWidth*3;
    
    self.ble = [BLEManager sharedInstance];
    self.ble.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
