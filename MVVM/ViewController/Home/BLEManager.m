//
//  BLEManager.m
//  MVVM
//
//  Created by wb on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BLEManager.h"

@implementation BLEManager

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
    [self.manager stopScan];
    
    if ([self.delegate respondsToSelector:@selector(BLEManager: didDiscoverPeripheral: advertisementData: RSSI:)]) {
        [self.delegate BLEManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}


// （3）连接外设后的处理 //连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    
    if ([self.delegate respondsToSelector:@selector(BLEManager: didConnectPeripheral:)]) {
        [self.delegate BLEManager:central didConnectPeripheral:peripheral];
    }
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
    if ([self.delegate respondsToSelector:@selector(BLEManager: didFailToConnectPeripheral: error:)]) {
        [self.delegate BLEManager:central didFailToConnectPeripheral:peripheral error:error];
    }
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"%@",[NSString stringWithFormat:@"距离：%@", length]);
}


// (4）发现服务和搜索到的Characteristice //已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    int i=0;
    for (CBService *s in peripheral.services) {
        i ++ ;
        NSLog(@"%@",[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]);
        [peripheral discoverCharacteristics:nil forService:s];
        if ([s.UUID isEqual:[CBUUID UUIDWithString:self.configModel.serviceUUID]]) {
        }
        
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@",[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]);
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"%@",[NSString stringWithFormat:@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID]);
        if ([c.UUID isEqual:[CBUUID UUIDWithString:self.configModel.characteristicWriteUUID]]) {
            self.writeCharacteristic = c;
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:self.configModel.characteristicReadUUID]]) {
            [_peripheral readValueForCharacteristic:c];
            [_peripheral setNotifyValue:YES forCharacteristic:c];
        }
    
    }
}


// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"已断开与设备:[%@]的连接", peripheral.name]);
    if ([self.delegate respondsToSelector:@selector(BLEManager: didDisconnectPeripheral: error:)]) {
        [self.delegate BLEManager:central didDisconnectPeripheral:peripheral error:error];
    }
    
}

//（5）获取外设发来的数据 //获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.configModel.characteristicReadUUID]]) {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        for(int i=0;i<[data length];i++) {
            printf("testByteFF02[%d] = %d\n",i,resultByte[i]);
        }
        
        if ([self.delegate respondsToSelector:@selector(BLEManager: didUpdateValueForCharacteristic: error:)]) {
            [self.delegate BLEManager:peripheral didUpdateValueForCharacteristic:characteristic error:error];
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        NSLog(@"%@",[NSString stringWithFormat:@"Notification stopped on %@.  Disconnecting", characteristic]);
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
    
}

//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];
    
    if ([self.delegate respondsToSelector:@selector(BLEManager: didWriteValueForCharacteristic: error:)]) {
        [self.delegate BLEManager:peripheral didWriteValueForCharacteristic:characteristic error:error];
    }
}

// 扫描
- (void)stopScan {
     [self.manager stopScan];
}

// 停止扫描
- (void)startScan {
    [self.manager scanForPeripheralsWithServices:nil  options:nil];
}

// 连接
- (void)connecting {
    // 连接外设
    [self.manager connectPeripheral:_peripheral options:nil];
}
@end
