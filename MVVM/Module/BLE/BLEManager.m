//
//  BLEManager.m
//  MVVM
//
//  Created by wb on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BLEManager.h"

@interface BLEManager ()
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;
@end

@implementation BLEManager

+ (id)sharedInstance {
    static BLEManager *userInfoDB;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoDB = [[BLEManager alloc]init];
    });
    return userInfoDB;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

// （1）检测蓝牙状态 开始查看服务，蓝牙开启
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"%@",@"蓝牙已打开,请扫描外设");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"%@",@"蓝牙没有打开,请先打开蓝牙");
            [SVProgressHUD showInfoWithStatus:@"蓝牙没有打开,请先打开蓝牙"];
            break;
        default:
            break;
    }
}

//（2）检测到外设后，停止扫描，连接设备 //查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@", [NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]);
    self.peripheral = peripheral;
    if ([_delegate respondsToSelector:@selector(BLEManager: didDiscoverPeripheral: advertisementData: RSSI:)]) {
        [self.delegate BLEManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

// （3）连接外设后的处理 //连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
    // 重新赋值
    self.peripheral = peripheral;
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    if ([_delegate respondsToSelector:@selector(BLEManager: didConnectPeripheral:)]) {
        [self.delegate BLEManager:central didConnectPeripheral:peripheral];
    }
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
    if ([_delegate respondsToSelector:@selector(BLEManager: didFailToConnectPeripheral: error:)]) {
        [self.delegate BLEManager:central didFailToConnectPeripheral:peripheral error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"%@",[NSString stringWithFormat:@"距离：%@", length]);

}

// (4）发现服务和搜索到的Characteristice //已发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(BLEManager:didDiscoverServices:)]) {
        [self.delegate BLEManager:peripheral didDiscoverServices:error];
    }
}

// 已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(BLEManager: didDiscoverCharacteristicsForService:error:)]) {
        [self.delegate BLEManager:peripheral didDiscoverCharacteristicsForService:service error:error];
    }
    
}

// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"已断开与设备:[%@]的连接", peripheral.name]);
    if ([_delegate respondsToSelector:@selector(BLEManager: didDisconnectPeripheral:error:)]) {
        [self.delegate BLEManager:central didDisconnectPeripheral:peripheral error:error];
    }
}

//（5）获取外设发来的数据 //获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([_delegate respondsToSelector:@selector(BLEManager: didUpdateValueForCharacteristic: error:)]) {
        [self.delegate BLEManager:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
    
}


//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
}

// 停止扫描
- (void)stopScan {
     [self.manager stopScan];
}

// 扫描
- (void)startScan {
    [self.manager scanForPeripheralsWithServices:nil  options:nil];
}

// 连接
- (void)connecting:(CBPeripheral *)peripheral {
    if (peripheral == nil) {
        return;
    }
    // 连接外设
    [self.manager connectPeripheral:peripheral options:nil];
}

// 断开连接
- (void)disConnecting:(CBPeripheral *)peripheral {
    if (peripheral == nil) {
        return;
    }
    [self.manager cancelPeripheralConnection:peripheral];
}

// 写数据
- (void)peripheral:(CBPeripheral *)peripheral writeData:(NSData *)data toCharacteristic:(CBCharacteristic *)characteristic {
    if (peripheral == nil) {
        return;
    }
    if (peripheral.state == CBPeripheralStateConnected) {
        NSString *str = [Tools convertDataToHexStr:data];
        NSLog(@"发送的指令：%@",str);
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

// 发现服务下的特征
- (void)peripheralDiscoverCharacteristics:(CBPeripheral *)peripheral forService:(CBService *)service {
    if (peripheral == nil) {
        return;
    }
    [peripheral discoverCharacteristics:nil forService:service];
}

// 注册读的通知
- (void)setNotifyValue:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    if (peripheral == nil) {
        return;
    }
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

- (void)readValue:(CBPeripheral *)peripheral forCharacteristic:(CBCharacteristic *)characteristic {
    if (peripheral == nil) {
        return;
    }
    [peripheral readValueForCharacteristic:characteristic];
}
@end
