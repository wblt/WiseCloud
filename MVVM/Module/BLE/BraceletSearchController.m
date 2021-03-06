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

#import "ShouhuanViewController.h"

#import "WaterElementController.h"

#import "RecordViewController.h"

#import "BalanceController.h"

@interface BraceletSearchController ()<UITableViewDataSource,UITableViewDelegate,BLEManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *devices;

@property (nonatomic, strong) NSMutableArray *dataArr;


@property (strong,nonatomic) BLEManager *ble;

@end

@implementation BraceletSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描设备";
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ([self.type isEqualToString:@"手环"]) {
        // 手环配置
        self.ble = [BLEManager sharedInstance];
        self.ble.delegate = self;
    } else if ([self.type isEqualToString:@"体脂称"]) {
        [self.dataArr removeAllObjects];
        BleScaningDecviceModel *bleModel1 = [[BleScaningDecviceModel alloc] init];
        bleModel1.deviceName = @"F100";
        bleModel1.uuid = @"F100";
        [self.dataArr addObject:bleModel1];
        
        BleScaningDecviceModel *bleModel2 = [[BleScaningDecviceModel alloc] init];
        bleModel2.deviceName = @"F200";
        bleModel2.uuid = @"F200";
        [self.dataArr addObject:bleModel2];
        
        BleScaningDecviceModel *bleModel3 = [[BleScaningDecviceModel alloc] init];
        bleModel3.deviceName = @"F300";
        bleModel3.uuid = @"F300";
        [self.dataArr addObject:bleModel3];
        
        [self.tableView reloadData];
        
        self.ble = [BLEManager sharedInstance];
        self.ble.delegate = self;
    } else if ([self.type isEqualToString:@"水分仪"]) {
        // 水分仪配置
        self.ble = [BLEManager sharedInstance];
        self.ble.delegate = self;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.ble stopScan];
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

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceCell *cell = [DeviceCell deviceCellWithTableView:tableView];
    BleScaningDecviceModel *bleModel = self.dataArr[indexPath.row];
    cell.bleScaningDeviceModel = bleModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.type isEqualToString:@"手环"]) {
        ShouhuanViewController *ShouhuanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShouhuanViewController"];
        ShouhuanVC.hidesBottomBarWhenPushed = YES;
        ShouhuanVC.bleModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:ShouhuanVC animated:YES];
    } else if ([self.type isEqualToString:@"体脂称"]) {
        // 进入体脂称的页面
        BalanceController *balanceVC = [[BalanceController alloc] init];
        balanceVC.bleModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:balanceVC animated:YES];
    } else if ([self.type isEqualToString:@"水分仪"]) {
        WaterElementController *waterVC = [[WaterElementController alloc] init];
        [self.navigationController pushViewController:waterVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
        // 添加设备
        [self.dataArr removeAllObjects];
        for (int i=0; i < self.devices.count; i++) {
            CBPeripheral *p = self.devices[i];
            if ([self.type isEqualToString:@"体脂称"]) {
                if ([p.name isEqualToString:@"BTL03001@H@Bwwws"]) {
                    BleScaningDecviceModel *bleModel = [[BleScaningDecviceModel alloc] init];
                    bleModel.deviceName = @"F300_1";
                    bleModel.uuid = p.identifier.UUIDString;
                    [self.dataArr addObject:bleModel];
                } else if([p.name isEqualToString:@"QN-Scale"]) {
                    BleScaningDecviceModel *bleModel = [[BleScaningDecviceModel alloc] init];
                    bleModel.deviceName = @"F100_1";
                    bleModel.uuid = p.identifier.UUIDString;
                    [self.dataArr addObject:bleModel];
                } else if ([p.name isEqualToString:@"YunChen"]) {
                    BleScaningDecviceModel *bleModel = [[BleScaningDecviceModel alloc] init];
                    bleModel.deviceName = @"F200_1";
                    bleModel.uuid = p.identifier.UUIDString;
                    [self.dataArr addObject:bleModel];
                }
            } else if([self.type isEqualToString:@"手环"]) {
                if ([p.name isEqualToString:@"Y2"]) {
                    BleScaningDecviceModel *bleModel = [[BleScaningDecviceModel alloc] init];
                    bleModel.deviceName = p.name;
                    bleModel.uuid = p.identifier.UUIDString;
                    [self.dataArr addObject:bleModel];
                }
            }
        }
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

// 用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
@end
