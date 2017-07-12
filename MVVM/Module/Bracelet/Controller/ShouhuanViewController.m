//
//  ShouhuanViewController.m
//  MVVM
//
//  Created by 冷婷 on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ShouhuanViewController.h"
#import "BLEManager.h"
#import "BraceletInstructions.h"

// =================手环==================
#define UUID_SERVICE_ShouHuan @"C3E6FEA0-E966-1000-8000-BE99C223DF6A"

#define UUID_READ_ShouHuan @"C3E6FEA2-E966-1000-8000-BE99C223DF6A"

#define UUID_WRITE_ShouHuan @"C3E6FEA1-E966-1000-8000-BE99C223DF6A"
// =================手环==================

@interface ShouhuanViewController ()<BLEManagerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourX;

@property (weak, nonatomic) IBOutlet UILabel *heatValue;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign,nonatomic) NSInteger lastIndex;

@property (assign,nonatomic) BOOL firstFlag;


@property (nonatomic,strong) BLEManager *ble;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;
@end

@implementation ShouhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.width.constant = kScreenWidth*4;
    self.secondX.constant = kScreenWidth;
    self.thridX.constant = kScreenWidth*2;
    self.fourX.constant = kScreenWidth*3;
    
    self.scrollView.delegate = self;
    self.lastIndex = 255;
    self.firstFlag = NO;
    self.ble = [BLEManager sharedInstance];
    self.ble.delegate = self;
    
    [self bleConnecting];
}

- (void)bleConnecting {
    [SVProgressHUD showWithStatus:@"发现设备中.."];
    // 重新扫描
    [self.ble startScan];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [self.ble disConnecting:self.peripheral];
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
        [SVProgressHUD showWithStatus:@"设备连接中。。"];
        [self.ble stopScan];
        self.peripheral = peripheral;
        [self.ble connecting:peripheral];
    }
}

// 连接成功
- (void)BLEManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.peripheral = peripheral;
    [SVProgressHUD showWithStatus:@"设备连接成功"];
    [SVProgressHUD dismiss];
}


// 连接失败
-(void)BLEManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"连接失败"];
}


// 发现服务
-(void)BLEManager:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
     int i=0;
     for (CBService *s in peripheral.services) {
     if ([s.UUID isEqual:[CBUUID UUIDWithString:UUID_SERVICE_ShouHuan]]) {
             NSLog(@"%@",[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]);
             [peripheral discoverCharacteristics:nil forService:s];
         }
     }
    
}

// 发现服务下的特征回调
-(void)BLEManager:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
     for (CBCharacteristic *c in service.characteristics) {
         // 设置读的特征
         if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_WRITE_ShouHuan]]) {
             NSLog(@"%@",[NSString stringWithFormat:@"写特征 UUID: %@ (%@)",c.UUID.data,c.UUID]);
             self.writeCharacteristic = c;
             [self.ble setNotifyValue:peripheral forCharacteristic:c];
         }
         
         if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_READ_ShouHuan]]) {
             NSLog(@"%@",[NSString stringWithFormat:@"读特征 UUID: %@ (%@)",c.UUID.data,c.UUID]);
             [self.ble readValue:peripheral forCharacteristic:c];
             [self.ble setNotifyValue:peripheral forCharacteristic:c];
         }
     }
    
    
    
}

// 断开连接
- (void)BLEManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"已断开设备连接"];
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)BLEManager:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
     if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_READ_ShouHuan]]) {
         NSString *newString = [Tools convertDataToHexStr:characteristic.value];
         NSLog(@"收到的数据：%@",newString);
         NSString *heatvalue = [newString substringWithRange:NSMakeRange(8,2)];
         heatvalue = [NSString stringWithFormat:@"%ld",strtoul([heatvalue UTF8String],0,16)];
         NSLog(@"%@",heatvalue);
         self.heatValue.text = heatvalue;
         NSData * data = characteristic.value;
         Byte *resultByte = (Byte *)[data bytes];
         for(int i=0;i<[data length];i++) {
             printf("testByteFF02[%d] = %d\n",i,resultByte[i]);
         }
         
         if (self.firstFlag == NO) {
             // 首次发送获取运动的数据
             NSString *str = [BraceletInstructions getMotionInstructions];
             NSLog(@"运动数据：%@",str);
             [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
             self.firstFlag = YES;
         }
         
     }
}

// 用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
// ===========================蓝牙代理======================

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    if (self.lastIndex != index) {
        NSLog(@"滑动至%d,该发送命令",index);
    } else {
        NSLog(@"滑动至%d",index);
    }
    self.lastIndex = index;
}

@end
