//
//  BLEManager.h
//  MVVM
//
//  Created by wb on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLEManagerDelegate <NSObject>

@optional

// 扫描回调
-(void)BLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

// 连接成功
- (void)BLEManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

// 连接失败
-(void)BLEManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

// 断开连接
- (void)BLEManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)BLEManager:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

//用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end

@interface BLEManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic,assign) id<BLEManagerDelegate> delegate;

+ (id)sharedInstance;

// 停止扫描
- (void)stopScan;

// 开始扫描
- (void)startScan;

// 连接
- (void)connecting:(CBPeripheral *)peripheral;

// 断开连接
- (void)disConnecting:(CBPeripheral *)peripheral;

// 写数据
- (void)writeData;
@end
