//
//  BleScaningConfigModel.h
//  MVVM
//
//  Created by wb on 2017/6/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPeripheralName     @"360qws Electric Bike Service" //外围设备名称

// =================手环==================
#define UUID_SERVICE_ShouHuan @"C3E6FEA0-E966-1000-8000-BE99C223DF6A"

#define UUID_READ_ShouHuan @"C3E6FEA2-E966-1000-8000-BE99C223DF6A"

#define UUID_WRITE_ShouHuan @"C3E6FEA1-E966-1000-8000-BE99C223DF6A"
// =================手环==================

// =================体脂==================
#define SERIAL_RATE 0.6
#define UUID_SERVICE @"0000fff0-0000-1000-8000-00805f9b34fb"
#define UUID_READ @"0000fff4-0000-1000-8000-00805f9b34fb"
#define UUID_WRITE @"0000fff1-0000-1000-8000-00805f9b34fb"
// =================体脂==================

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
