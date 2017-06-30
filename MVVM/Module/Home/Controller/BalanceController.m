//
//  BalanceController.m
//  MVVM
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BalanceController.h"
#import "BodyFatCell.h"
#import "RecordViewController.h"
#import "ChangUserController.h"
#import "BLEManager.h"
#import "TargetViewController.h"

// =================体脂==================
#define SERIAL_RATE 0.6

#define UUID_SERVICE @"0000fff0-0000-1000-8000-00805f9b34fb"

#define UUID_READ @"0000fff4-0000-1000-8000-00805f9b34fb"

#define UUID_WRITE @"0000fff1-0000-1000-8000-00805f9b34fb"
// =================体脂==================

@interface BalanceController ()<UITableViewDelegate,UITableViewDataSource,BLEManagerDelegate,sendDelegate>
@property (nonatomic,strong) UITableView *cutableView;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *unitArray;
@property (nonatomic,strong) BLEManager *ble;
@property (nonatomic,strong) SendDataToDevice *send;
@property (nonatomic,strong) QingNiuDevice *qingNiuDevice;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic,strong) CBCharacteristic *WriteCharacteristic;
@property (nonatomic,strong) CBCharacteristic *ReadCharacteristic;
@property (nonatomic,assign) BOOL is_mode_loite;

@end

@implementation BalanceController {
    NSString *identify;
    NSString *currentWater;
    NSString *currentWeight;
    UILabel *titleLabel;
    UILabel *bigWightLabel;
    NSString *curretnValue;
    UILabel *waterResult;
    UILabel *bodyFatResult;
    UILabel *bigGradeLabel;
    UILabel *changeLabel;
    NSMutableDictionary *dicData;
    NSMutableArray *dataSouce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dicData = [NSMutableDictionary dictionary];
    dataSouce = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initName];
    [self initUnit];
    //创建表视图
    identify = @"BodyFatCell";
    [self createTableView];
    [self initRightBtn];
    
    // 切换电子称
    [self switchBle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    // 判断电子称
    if ([self.bleModel.deviceName rangeOfString:@"F100"].location != NSNotFound) {
        // 青牛电子称
        [self QingNiuDisconnect];
    } else if ([self.bleModel.deviceName rangeOfString:@"F200"].location != NSNotFound) {
        // 云称
        if (self.peripheral) {
            [self.ble disConnecting:self.peripheral];
        }
    } else if ([self.bleModel.deviceName rangeOfString:@"F300"].location != NSNotFound) {
        // 兴瑞智
        [self.send disconnectDevice];
    }
}

- (void)switchBle {
    // 判断电子称
    if ([self.bleModel.deviceName rangeOfString:@"F100"].location != NSNotFound) {
        // 设置真实的蓝牙名称
        self.bleModel.realName = @"QN_Scale";
        // 青牛电子称
        // 验证APP
        [QingNiuSDK registerApp:@"123456789"/*@"123456asdfg" */registerAppBlock:^(QingNiuRegisterAppState qingNiuRegisterAppState) {
            NSLog(@"%ld",(long)qingNiuRegisterAppState);
        }];
    } else if ([self.bleModel.deviceName rangeOfString:@"F200"].location != NSNotFound) {
        // yunchen
        // 设置真实的蓝牙名称
        self.bleModel.realName = @"YunChen";
        // 获取蓝牙信息
        self.ble = [BLEManager sharedInstance];
        self.ble.delegate = self;
    } else if ([self.bleModel.deviceName rangeOfString:@"F300"].location != NSNotFound) {
        // 设置真实的蓝牙名称
        self.bleModel.realName = @"BTL03001@H@Bwwws";
        // 鑫睿智
        self.send = [SendDataToDevice getSendDataToDeviceInstance];
        self.send.delegate = self;
        [self.send myInit];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    changeLabel.text = userModel.testUserModel.name;
}

- (void)initRightBtn {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(historyRecorderList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)historyRecorderList
{
    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"Manage" bundle:nil];
    RecordViewController *recordVC = [storyboad instantiateViewControllerWithIdentifier:@"RecordViewController"];
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)initName {
    [self.nameArray addObject:@"去脂体重"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"基础代谢量"];
    [self.nameArray addObject:@"皮下脂肪量"];
    [self.nameArray addObject:@"内脏脂肪等级"];
    [self.nameArray addObject:@"肌肉量"];
    [self.nameArray addObject:@"骨骼肌率"];
    [self.nameArray addObject:@"骨量"];
    [self.nameArray addObject:@"体年龄"];
    [self.nameArray addObject:@"腰臀比"];
}

- (void)initUnit {
    [self.unitArray addObject:@"kg"];
    [self.unitArray addObject:@""];
    [self.unitArray addObject:@"kcal"];
    [self.unitArray addObject:@"%"];
    [self.unitArray addObject:@"级"];
    [self.unitArray addObject:@"kg"];
    [self.unitArray addObject:@"%"];
    [self.unitArray addObject:@"kg"];
    [self.unitArray addObject:@"岁"];
    [self.unitArray addObject:@""];
}

- (void)createTableView {
    self.cutableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.cutableView.dataSource = self;
    self.cutableView.delegate = self;
    //设置头视图
    self.cutableView.tableHeaderView = [self createTableHeadView];
    self.cutableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:self.cutableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BodyFatCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[BodyFatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.nameLabel.text = self.nameArray[indexPath.row];
    cell.unitLabel.text = self.unitArray[indexPath.row];
    
    if (dataSouce.count > 0) {
        cell.resultLabel.text = dataSouce[indexPath.row];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (UIView *)createTableHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    //蓝牙未连接
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"----";
    [headView addSubview:titleLabel];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"测量" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:testButton];
    
    //大的圈圈
    UIImageView *resultImgeView = [[UIImageView alloc] init];
    resultImgeView.image = [UIImage imageNamed:@"tzbeijing"];
    [headView addSubview:resultImgeView];
    
    resultImgeView.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    //为图片添加手势
    [resultImgeView addGestureRecognizer:singleTap];

    //大圈圈的分数
    bigGradeLabel = [[UILabel alloc] init];
    bigGradeLabel.text = @"0.0分";
    bigGradeLabel.textColor = [UIColor orangeColor];
    bigGradeLabel.font = [UIFont systemFontOfSize:13];
    bigGradeLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:bigGradeLabel];
    
    //分割线
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:sepLine];
    
    //大圈圈的结果
    bigWightLabel = [[UILabel alloc] init];
    currentWeight = @"0";
    bigWightLabel.text = [NSString stringWithFormat:@"%@kg",currentWeight];
    bigWightLabel.font = [UIFont systemFontOfSize:13];
    bigWightLabel.textColor = [UIColor orangeColor];
    bigWightLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:bigWightLabel];
    
    //切换账号
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    changeLabel = [[UILabel alloc] init];
    changeLabel.text = userModel.testUserModel.name;
    [headView addSubview:changeLabel];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:changeButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).with.offset(15);
        make.top.equalTo(headView).with.offset(10);
    }];
    
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(titleLabel);
        make.left.equalTo(titleLabel);
        make.right.equalTo(titleLabel);
    }];
    
    
    [resultImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView);
    }];
    
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).with.offset(-15);
        make.top.equalTo(headView).with.offset(10);
        
    }];
    
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changeLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(changeLabel);
        make.left.equalTo(changeLabel);
        make.right.equalTo(changeLabel);
    }];
    
    UILabel *waterLabel = [[UILabel alloc] init];
    waterLabel.text = @"体水分";
    [headView addSubview:waterLabel];
    
    UIImageView *waterImageView = [[UIImageView alloc] init];
    waterImageView.image = [UIImage imageNamed:@"tishuibeijing"];
    [headView addSubview:waterImageView];
    
    waterResult = [[UILabel alloc] init];
    waterResult.text = @"%0.0";
    waterResult.font = [UIFont systemFontOfSize:13];
    [headView addSubview:waterResult];
    
    [waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).with.offset(-5);
        make.left.equalTo(headView).with.offset(10);
    }];
    
    [waterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(waterLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(waterLabel);
    }];
    
    [waterResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(waterImageView);
        make.centerY.equalTo(waterImageView);
    }];
    
    UILabel *bodyFatLabel = [[UILabel alloc] init];
    bodyFatLabel.text = @"体脂率";
    [headView addSubview:bodyFatLabel];
    
    
    UIImageView *bodyFatImgeView = [[UIImageView alloc] init];
    bodyFatImgeView.image = [UIImage imageNamed:@"tishuibeijing"];
    [headView addSubview:bodyFatImgeView];
    
    bodyFatResult = [[UILabel alloc] init];
    bodyFatResult.text = @"%0.0";
    bodyFatResult.font = [UIFont systemFontOfSize:13];
    [headView addSubview:bodyFatResult];
    
    [bodyFatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).with.offset(-5);
        make.right.equalTo(headView).with.offset(-10);
    }];
    
    [bodyFatImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bodyFatLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(bodyFatLabel);
    }];
    
    [bodyFatResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bodyFatImgeView);
        make.centerY.equalTo(bodyFatImgeView);
    }];
    
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resultImgeView).with.offset(10);
        make.centerY.equalTo(resultImgeView);
        make.centerX.equalTo(resultImgeView);
        make.right.equalTo(resultImgeView).with.offset(-10);
        make.height.mas_equalTo(2);
    }];
    
    [bigGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sepLine);
        make.bottom.equalTo(sepLine.mas_top).with.offset(-10);
    }];
    
    
    [bigWightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sepLine);
        make.top.equalTo(sepLine.mas_bottom).with.offset(10);
    }];
    return headView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (NSMutableArray *)nameArray{
    if (_nameArray == nil) {
        _nameArray = [[NSMutableArray alloc] init];
    }
    return _nameArray;
}

- (NSMutableArray *)unitArray{
    if (_unitArray == nil) {
        _unitArray = [[NSMutableArray alloc] init];
    }
    return _unitArray;
}


#pragma mark - 测量
- (void)testAction:(UIButton *)sender {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    TestUserModel *testModel = userModel.testUserModel;
    // 先检测test用户
    if (testModel == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择测量用户"];
        return;
    }
    [SVProgressHUD showWithStatus:@"设备连接中..."];
    titleLabel.text = [NSString stringWithFormat:@"%@", self.bleModel.deviceName];
    // 判断电子称
    if ([self.bleModel.deviceName rangeOfString:@"F100"].location != NSNotFound) {
        // 青牛电子称
        [SVProgressHUD showWithStatus:@"开始扫描"];
        [self QingNiuScanBle];
    } else if ([self.bleModel.deviceName rangeOfString:@"F200"].location != NSNotFound) {
        // 云称
        [SVProgressHUD showWithStatus:@"开始扫描"];
        [self.ble startScan];
    } else if ([self.bleModel.deviceName rangeOfString:@"F300"].location != NSNotFound) {
        // 兴瑞智
        [self.send starScanningDevice];
    }
    
}

#pragma mark - 切换账号
- (void)changAction:(UIButton *)sender {
    ChangUserController *changVC = [[ChangUserController alloc] init];
    [self.navigationController pushViewController:changVC animated:YES];
}

- (NSString *)getBmi:(float)tz {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    TestUserModel *testModel = userModel.testUserModel;
    CGFloat sgs = [testModel.height floatValue] / 100;
    NSInteger bmi = tz / (sgs * sgs);
    return [NSString stringWithFormat:@"%ld",(long)bmi];
}

- (NSString *)yaotunbi {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    TestUserModel *testModel = userModel.testUserModel;
    NSInteger bi = [testModel.waist floatValue] / [testModel.hip floatValue];
    return [NSString stringWithFormat:@"%ld",(long)bi];
}

// 结果点击相应事件
-(void)singleTapAction:(UIGestureRecognizer *)ges {
    NSLog(@"点击了");
    // 判断分数
    if ([bigGradeLabel.text isEqualToString:@"0.0分"]) {
        [SVProgressHUD showInfoWithStatus:@"请先测量你的体重"];
        [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    } else {
        //具体的实现
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Home" bundle:nil];
        TargetViewController *BraceletVC = [story instantiateViewControllerWithIdentifier:@"TargetViewController"];
        BraceletVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:BraceletVC animated:YES];

    }
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<青牛代理方法<<<<<<<<<<<<<<<<<<<<
- (void)QingNiuRegisterAPP
{
    [QingNiuSDK registerApp:@"123456789"/*@"123456asdfg" */registerAppBlock:^(QingNiuRegisterAppState qingNiuRegisterAppState) {
        NSLog(@"%ld",(long)qingNiuRegisterAppState);
    }];
}

#pragma mark 扫描
- (void)QingNiuScanBle
{
    [QingNiuSDK startBleScan:nil scanSuccessBlock:^(QingNiuDevice *qingNiuDevice) {
        NSLog(@"%@",qingNiuDevice.name);
        if ([qingNiuDevice.name isEqualToString:@"QN-Scale"]) {
            self.qingNiuDevice = qingNiuDevice;
            [SVProgressHUD showWithStatus:@"开始连接"];
            // 停止扫描
            [self QingNiuStopScan];
            // 连接
            [self QingNiuConnect];
        }
    } scanFailBlock:^(QingNiuScanDeviceFail qingNiuScanDeviceFail) {
        NSLog(@"%ld",(long)qingNiuScanDeviceFail);
        
    }];
}


- (void)QingNiuStopScan
{
    [QingNiuSDK stopBleScan];
}


- (void)QingNiuConnect
{
    QingNiuUser *user = [[QingNiuUser alloc] init];
    user.userId = @"pyf";
    user.height = 176;
    user.gender = 1;
    user.birthday = @"1992-01-10";
    [QingNiuSDK connectDevice:_qingNiuDevice user:user connectSuccessBlock:^(NSMutableDictionary *deviceData, QingNiuDeviceConnectState qingNiuDeviceConnectState) {
        if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateConnectedSuccess) {
            [SVProgressHUD showWithStatus:@"连接成功"];
            NSLog(@"连接成功%@",deviceData);
        }
        else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsWeighting) {
            NSLog(@"实时体重：%@",deviceData[@"weight"]);
        }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateWeightOver){
            NSLog(@"测量完毕：%@",deviceData);
        }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateIsGettingSavedData){
            NSLog(@"正在获取存储数据：%@",deviceData);
        }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateGetSavedDataOver){
            NSLog(@"存储数据接收完毕：%@",deviceData);
        }else if (qingNiuDeviceConnectState == QingNiuDeviceConnectStateDisConnected) {
            NSLog(@"自动断开连接%@",deviceData);
            [SVProgressHUD showWithStatus:@"连接失败"];
        }
    } connectFailBlock:^(QingNiuDeviceConnectState qingNiuDeviceConnectState) {
        NSLog(@"%ld",(long)qingNiuDeviceConnectState);
        [SVProgressHUD showWithStatus:@"连接失败"];
    }];
}


- (void)QingNiuDisconnect
{
    [QingNiuSDK cancelConnect:_qingNiuDevice disconnectFailBlock:^(QingNiuDeviceDisconnectState qingNiuDeviceDisconnectState) {
        NSLog(@"%ld",(long)qingNiuDeviceDisconnectState);
    } disconnectSuccessBlock:^(QingNiuDeviceDisconnectState qingNiuDeviceDisconnectState) {
        NSLog(@"%ld",(long)qingNiuDeviceDisconnectState);
    }];
}


- (void)QingNiuClearCache
{
    [QingNiuSDK clearCache];
}

// >>>>>>>>>>>>>>>>>>>>>>>>>青牛智代理方法>>>>>>>>>>>>>>>>>>>>>>>>>


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<Yunchen代理方法<<<<<<<<<<<<<<<<<<<<<<<<
// 扫描回调
-(void)BLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]);
    if ([peripheral.name isEqualToString:@"YunChen"]) {
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
    
}
// 断开连接
- (void)BLEManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)BLEManager:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_READ]]) {
        NSString *newString = [self convertDataToHexStr:characteristic.value];
        NSLog(@"%@",newString);
        if (newString.length == 40) {
            NSLog(@"%@",characteristic);
            NSString *temp = @"";
            dataSouce = [NSMutableArray array];
            //状态
            NSString *zhuangtai = [newString substringWithRange:NSMakeRange(2,2)];
            
            zhuangtai = [NSString stringWithFormat:@"%ld",strtoul([zhuangtai UTF8String],0,16)];
            
            NSLog(@"%@",zhuangtai);
            
            if (zhuangtai.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",zhuangtai];
            }
            
            //脂肪
            NSString *zhifang = [newString substringWithRange:NSMakeRange(8,4)];
            
            zhifang = [NSString stringWithFormat:@"%.2f",strtoul([zhifang UTF8String],0,16)/10.0];
            
            // 体脂率
            bodyFatResult.text = [NSString stringWithFormat:@"%%%@",zhifang];
            
            if (zhifang.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",zhifang];
            }
            NSLog(@"%@",zhifang);
            //重量
            NSString *zl = [newString substringWithRange:NSMakeRange(4,4)];
            zl = [NSString stringWithFormat:@"%.2f",strtoul([zl UTF8String],0,16)/100.0];
            
            if (zl.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",zl];
            }
            
            NSLog(@"%@",zl);
        
            //体水分
            NSString *sf = [newString substringWithRange:NSMakeRange(16,4)];
            sf = [NSString stringWithFormat:@"%.2f",strtoul([sf UTF8String],0,16)/10.0];
            
            if (sf.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",sf];
            }
            
            NSLog(@"%@",sf);
            
            
            //肌肉
            NSString *jr = [newString substringWithRange:NSMakeRange(20,4)];
            jr = [NSString stringWithFormat:@"%.2f",strtoul([jr UTF8String],0,16)/10.0];
            
            if (jr.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",jr];
            }
            
            NSLog(@"%@",jr);
            
    
            //骨骼
            NSString *gg = [newString substringWithRange:NSMakeRange(24,4)];
            gg = [NSString stringWithFormat:@"%.2f",strtoul([gg UTF8String],0,16)/10.0];
            
            if (gg.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",gg];
            }
            
            NSLog(@"%@",gg);
            
            //新陈代谢
            NSString *kaluli = [newString substringWithRange:NSMakeRange(28,4)];
            kaluli = [NSString stringWithFormat:@"%ld",strtoul([kaluli UTF8String],0,16)];
            
            if (kaluli.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",kaluli];
            }
            
            NSLog(@"%@",kaluli);
            
            //内脏等级
            NSString *neizhang = [newString substringWithRange:NSMakeRange(32,2)];
            neizhang = [NSString stringWithFormat:@"%.2f",strtoul([neizhang UTF8String],0,16)/10.0];
            if (neizhang.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",neizhang];
            }
            
            NSLog(@"%@",neizhang);
            

            //体年龄
            NSString *tiage = [newString substringWithRange:NSMakeRange(34,2)];
            tiage = [NSString stringWithFormat:@"%ld",strtoul([tiage UTF8String],0,16)];
            
            if (tiage.length != 0) {
                temp = [temp stringByAppendingFormat:@"|%@",tiage];
            }
            
            NSLog(@"%@",tiage);
            NSString *str = [NSString stringWithFormat:@"源:%@,解析:%@",characteristic,temp];
            
            curretnValue = str;
            NSLog(@"@@@@%@",curretnValue);
            //体重
            NSString *r1 = zl;
            currentWeight = r1;
            bigWightLabel.text = [NSString stringWithFormat:@"%@kg",currentWeight];
            //去脂体重
            [dataSouce addObject:r1];
            [dicData setValue:r1 forKey:@"去脂体重"];
            //bmi
            NSString *r2 = [self getBmi:[zl floatValue]];
            [dataSouce addObject:r2];
            [dicData setValue:r2 forKey:@"BMI"];
            //基础代谢
            NSString *r3 = kaluli;
            [dataSouce addObject:r3];
            [dicData setValue:r3 forKey:@"基础代谢量"];
            //皮下脂肪
            NSString *r4 = zhifang;
            [dataSouce addObject:r4];
            [dicData setValue:r4 forKey:@"皮下脂肪量"];
            //内脏
            NSString *r5 = neizhang;
            [dataSouce addObject:r5];
            [dicData setValue:r5 forKey:@"内脏脂肪等级"];
            //肌肉
            NSString *r6 = jr;
            [dataSouce addObject:r6];
            [dicData setValue:r6 forKey:@"肌肉量"];
            //骨骼
            NSString *r7 = gg;
            [dataSouce addObject:r7];
            [dicData setValue:r7 forKey:@"骨骼肌率"];
            //骨量
            NSString *r8 = gg;
            [dataSouce addObject:r8];
            [dicData setValue:r8 forKey:@"骨量"];
            //体水分
            currentWater = sf;
            waterResult.text = [NSString stringWithFormat:@"%%%@",sf];
            [dicData setValue:waterResult.text forKey:@"体水分"];
            // 体年龄
            [dataSouce addObject:tiage];
            [dicData setValue:tiage forKey:@"体年龄"];
            // 腰臀比
            NSString *yaotunbi = [self yaotunbi];
            [dicData setValue:yaotunbi forKey:@"腰臀比"];
            [dataSouce addObject:yaotunbi];
            //大圈圈的分数
            if (tiage.length != 0) {
                NSInteger value = arc4random() % 30 + 50;
                bigGradeLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
                [dicData setValue:bigGradeLabel.text forKey:@"分数"];
            }
            [self.cutableView reloadData];
            NSLog(@"%@",dicData);
        }
    }
}

//用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

// 发现服务
-(void)BLEManager:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSArray *services = nil;
    if (peripheral != self.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    services = [peripheral services];
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    int i=0;
    for (CBService *s in services) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:UUID_SERVICE]]) {
            NSLog(@"%@",[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]);
            self.peripheral = peripheral;
            [peripheral discoverCharacteristics:nil forService:s];
        }
    }
}

// 发现服务下的特征回调
-(void)BLEManager:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"characteristics:%@",[service characteristics]);
    if (peripheral != self.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    for (CBCharacteristic *characteristic in [service characteristics]) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_READ]]) {
            self.ReadCharacteristic = characteristic;
            self.peripheral = peripheral;
            [self.ble setNotifyValue:peripheral forCharacteristic:self.ReadCharacteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_WRITE]]) {
            self.WriteCharacteristic = characteristic;
            self.peripheral = peripheral;
            [self.ble setNotifyValue:peripheral forCharacteristic:self.WriteCharacteristic];
            self.is_mode_loite = YES;
            [self writeChar];
        }
    }
}
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Yunchen代理方法>>>>>>>>>>>>>>>>>>>>>>


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<辛睿智代理方法<<<<<<<<<<<<<<<<<<<<<<<<<<
-(void)getPeripheralsForScan:(CBPeripheral*)peripheral {
    if ([peripheral.name rangeOfString:@"BTL03001@H@B"].location != NSNotFound) {
        [SVProgressHUD showWithStatus:@"连接设备"];
        // 停止扫描
        [self.send stopScanningDevice];
        // 连接
        [self.send connectDevice:peripheral timeout:30];
    }
}
/*
 *获取蓝牙与设备的状态
 *@param State : 0(断开)，1（链接），2表示（链接成功需要ota升级）
 */
-(void)getBluetoothState:(int)State {
    NSLog(@"State==%d",State);
    if (State==1) {
        //已经连接
        [SVProgressHUD showWithStatus:@"连接成功"];
        [SVProgressHUD dismiss];
    }
    else if(State==0) {
        //断开连接
        [SVProgressHUD showWithStatus:@"断开连接"];
        [SVProgressHUD dismiss];
    }
}
-(void)getBluetoothDataForScale:(NSDictionary*)dic {
    NSLog(@"数据源1：dic==%@",dic);
}
-(void)getBluetoothData:(NSDictionary*)bluethoothDataDic {
    NSLog(@"数据源2：dic==%@",bluethoothDataDic);

}
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>辛睿智代理方法>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#pragma mark 写数据
-(void)writeChar
{
    //获取到特征 发送值
    NSString *ss = @"A50019AF505A19";
    NSData *dd = [self hexToBytes:ss];
    NSLog(@"peripheral did connect");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"%d", self.is_mode_loite);
        while (self.is_mode_loite) {
            NSLog(@"%ld",(long)self.peripheral.state);
            [NSThread sleepForTimeInterval:SERIAL_RATE];
            if (self.WriteCharacteristic && self.peripheral.state == CBPeripheralStateConnected) {
                // 这里应该封装
                [self.ble peripheral:self.peripheral writeData:dd toCharacteristic:self.WriteCharacteristic];
            }
            else {
                self.is_mode_loite = NO;
            }
        }
        NSLog(@"stopped");
        dispatch_async(dispatch_get_main_queue(), ^{
            // 断开连接了
            titleLabel.text = [NSString stringWithFormat:@"(YunChen)已断开"];
        });
    });
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange,BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) &0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

-(NSData*)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end
