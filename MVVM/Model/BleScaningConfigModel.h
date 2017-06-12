//
//  BleScaningConfigModel.h
//  MVVM
//
//  Created by wb on 2017/6/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPeripheralName     @"360qws Electric Bike Service" //外围设备名称

@interface BleScaningConfigModel : NSObject

// 外设名称
@property (nonatomic,strong) NSString *peripheralName;

// 服务号
@property (nonatomic,strong) NSString *serviceUUID;

// 向外设写数据
@property (nonatomic,strong) NSString *characteristicWriteUUID;

// 读取外设数据
@property (nonatomic,strong) NSString *characteristicReadUUID;

// 外设类型
@property (nonatomic,strong) NSString *peripheralType;

@end
