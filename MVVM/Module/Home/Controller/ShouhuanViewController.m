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

// 断开连接
- (IBAction)bleDisConnectAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否断开手环连接" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
