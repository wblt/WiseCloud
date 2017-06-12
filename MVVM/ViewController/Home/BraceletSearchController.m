//
//  BraceletSearchController.m
//  MVVM
//
//  Created by wb on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BraceletSearchController.h"

#import "BleScaningDecviceModel.h"

#import "BLEManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "DeviceCell.h"

@interface BraceletSearchController ()<UITableViewDataSource,UITableViewDelegate,BLEManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong,nonatomic) NSMutableArray *devices;

@property (strong,nonatomic) BLEManager *ble;

@end

@implementation BraceletSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描设备";
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 手环配置
    BleScaningConfigModel *config = [[BleScaningConfigModel alloc] init];
    config.serviceUUID = UUID_SERVICE_ShouHuan;
    config.characteristicWriteUUID = UUID_WRITE_ShouHuan;
    config.characteristicReadUUID = UUID_READ_ShouHuan;
    self.ble = [[BLEManager alloc] init];
    self.ble.configModel = config;
    self.ble.delegate = self;
}

- (IBAction)stopSearching:(id)sender {
    [self.ble stopScan];
    [SVProgressHUD dismiss];
}

- (IBAction)searching:(id)sender {
    [SVProgressHUD showWithStatus:@"扫描中"];
    [self.ble startScan];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)devices{
    if (_devices == nil) {
        _devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceCell *cell = [DeviceCell deviceCellWithTableView:tableView];
    BleScaningDecviceModel *bleModel = self.devices[indexPath.row];
    cell.bleScaningDeviceModel = bleModel;
    return cell;
}



// 扫描回调
-(void)BLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    BOOL replace = NO;
    // Match if we have this device from before
    for (int i=0; i < self.devices.count; i++) {
        CBPeripheral *p = [self.devices objectAtIndex:i];
        if ([p isEqual:peripheral]) {
            [self.devices replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    if (!replace) {
        [self.devices addObject:peripheral];
        [self.tableView reloadData];
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

//用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}





@end
