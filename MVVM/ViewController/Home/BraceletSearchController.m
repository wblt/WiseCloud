//
//  BraceletSearchController.m
//  MVVM
//
//  Created by wb on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BraceletSearchController.h"

#import "BleScaningDecviceModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "DeviceCell.h"

@interface BraceletSearchController ()<CBCentralManagerDelegate, CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CBCentralManager *manager;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (strong,nonatomic) NSMutableArray *devices;

@end

@implementation BraceletSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描设备";
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (IBAction)stopSearching:(id)sender {
    [self.manager stopScan];
}

- (IBAction)searching:(id)sender {
    [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.configModel.serviceUUID]]  options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// （1）检测蓝牙状态 开始查看服务，蓝牙开启
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"%@",@"蓝牙已打开,请扫描外设");
            [SVProgressHUD showInfoWithStatus:@"蓝牙已打开,请扫描外设"];
            
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
    
    
    
    // 连接外设
    //[self.manager connectPeripheral:_peripheral options:nil];
}


// （3）连接外设后的处理 //连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]);
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
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
        
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@",[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]);
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"%@",[NSString stringWithFormat:@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID]);
        
        
        
        
    }
}


// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"已断开与设备:[%@]的连接", peripheral.name]);
}

//（5）获取外设发来的数据 //获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
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
@end
