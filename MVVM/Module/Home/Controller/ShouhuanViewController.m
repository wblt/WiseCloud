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
@property (nonatomic, strong) CBPeripheral *peripheral;


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
    
    [self bleConnecting];
}

- (void)bleConnecting {
    [SVProgressHUD showWithStatus:@"发现设备中.."];
    // 重新扫描
    [self.ble startScan];
}

// 断开连接
- (IBAction)bleDisConnectAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否断开手环连接" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 点击好的处理 断开蓝牙连接
        [self.ble disConnecting:self.peripheral];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// ===========================蓝牙代理======================
// 扫描回调
-(void)BLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]);
    if ([peripheral.name isEqualToString:@"Y2"]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showWithStatus:@"设备连接中。。"];
        [self.ble stopScan];
        self.peripheral = peripheral;
    }
}

// 连接成功
- (void)BLEManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
}

// 连接失败
-(void)BLEManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

// 断开连接
- (void)BLEManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)BLEManager:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

// 用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
// ===========================蓝牙代理======================

@end
