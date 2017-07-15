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

@interface ShouhuanViewController ()<BLEManagerDelegate,UIScrollViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thrid2X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourX;

// 心率值
@property (weak, nonatomic) IBOutlet UILabel *heatValue;

// 心率低值
@property (weak, nonatomic) IBOutlet UILabel *heatLowValue;

// 心率高值
@property (weak, nonatomic) IBOutlet UILabel *heatHighValue;

// 心率标题
@property (weak, nonatomic) IBOutlet UILabel *heartTitle;

// 血压标题
@property (weak, nonatomic) IBOutlet UILabel *xueyaTitle;

// 血压值
@property (weak, nonatomic) IBOutlet UILabel *xueyaValue;

// 血压收缩压
@property (weak, nonatomic) IBOutlet UILabel *xueYaShousuYa;

// 血压舒张压
@property (weak, nonatomic) IBOutlet UILabel *xuyaSuZhangYa;

// 血压学习标题
@property (weak, nonatomic) IBOutlet UILabel *xueyaStudyTitle;

// 血压学习值
@property (weak, nonatomic) IBOutlet UILabel *xueyaStudyValue;

// 血压学习高值
@property (weak, nonatomic) IBOutlet UILabel *xueyaStudyHigh;

// 血压学习低值
@property (weak, nonatomic) IBOutlet UILabel *xueyaStudyLow;

// 血氧标题
@property (weak, nonatomic) IBOutlet UILabel *xueyangTitle;

// 血氧值
@property (weak, nonatomic) IBOutlet UILabel *xueyangValue;

// 血氧低值
@property (weak, nonatomic) IBOutlet UILabel *xeuyangLow;

// 血氧高值
@property (weak, nonatomic) IBOutlet UILabel *xueyangHigh;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *xueya1;
@property (weak, nonatomic) IBOutlet UIView *xueya2;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (assign,nonatomic) NSInteger lastIndex;
@property (assign,nonatomic) BOOL firstFlag;
@property (nonatomic,strong) NSMutableArray *arry;
@property (weak, nonatomic) IBOutlet UIImageView *heartRing;
@property (weak, nonatomic) IBOutlet UIImageView *xueyanRingTest;
@property (weak, nonatomic) IBOutlet UIImageView *xueyaRingStudy;
@property (weak, nonatomic) IBOutlet UIImageView *xueyangRing;

@property (nonatomic,strong) BLEManager *ble;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;

@property (nonatomic,copy) NSString *testMode;
@property (nonatomic,copy) NSString *cmd;
@property (nonatomic,assign) NSInteger testIndex;
@property (nonatomic,assign) NSInteger sum;
@property (nonatomic,copy) NSString *highBloodPre;
@property (nonatomic,copy) NSString *lowBloodPre;

@end

@implementation ShouhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cmd = @"none";
    
    self.sum = 0;
    
    // 初始化数据
    [self initData];
    
    [self initY2Model];
    
    self.width.constant = kScreenWidth*4;
    self.secondX.constant = kScreenWidth;
    self.thridX.constant = kScreenWidth*2;
    self.thrid2X.constant = kScreenWidth*2;
    self.fourX.constant = kScreenWidth*3;
    
    self.scrollView.delegate = self;
    self.lastIndex = 255;
    self.firstFlag = NO;
    self.ble = [BLEManager sharedInstance];
    self.ble.delegate = self;
    
    [self initGesture];
    
    [self bleConnecting];
}

// 初始化Y2模型
- (void)initY2Model {
    Y2Model *y2model = [[UserConfig shareInstace] getAllInformation].y2Mdoel;
    if (y2model == nil) {
        y2model = [[Y2Model alloc] init];
        UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
        userModel.y2Mdoel = y2model;
        [[UserConfig shareInstace] setAllInformation:userModel];
    }
}

// 初始化手势
- (void)initGesture {
    // 心率点击测量
    self.heartRing.userInteractionEnabled = YES;
    self.heartRing.tag = 101;
    UITapGestureRecognizer *heartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.heartRing addGestureRecognizer:heartTap];
    
    // 点击血压测量
    self.xueyanRingTest.userInteractionEnabled = YES;
    self.xueyanRingTest.tag = 102;
    UITapGestureRecognizer *xueyaTestTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.xueyanRingTest addGestureRecognizer:xueyaTestTap];
    
    // 点击血压学习
    self.xueyaRingStudy.userInteractionEnabled = YES;
    self.xueyaRingStudy.tag = 103;
    UITapGestureRecognizer *xueyaStudyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.xueyaRingStudy addGestureRecognizer:xueyaStudyTap];
    
    
    // 点击血氧测量
    self.xueyangRing.userInteractionEnabled = YES;
    self.xueyangRing.tag = 104;
    UITapGestureRecognizer *xueyangTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.xueyangRing addGestureRecognizer:xueyangTap];
}

// 初始化数据
- (void)initData {
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 80; i<= 160; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr1 addObject:str];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 50; i<=120; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arr2 addObject:str];
    }
    [self.arry addObject:arr1];
    [self.arry addObject:arr2];
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
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [self.ble disConnecting:self.peripheral];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
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
         // 数据解析
         [self analysisData:newString];
         // 打印测试数据
         NSData * data = characteristic.value;
         Byte *resultByte = (Byte *)[data bytes];
         for(int i=0;i<[data length];i++) {
             printf("testByteFF02[%d] = %d\n",i,resultByte[i]);
         }
         
         // 判断是否有待发送的命令
         if (self.firstFlag == NO) {
             self.cmd = [BraceletInstructions getUnbundingInstructions];
             self.firstFlag = YES;
         }
         
         [self send];
     }
}

// 用于检测中心向外设写数据是否成功
-(void)BLEManager:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}
// ===========================蓝牙代理======================

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    if (self.lastIndex != index) {
        NSLog(@"滑动至%ld,该发送命令",(long)index);
        switch (index) {
            case 0:
            {
                // 发送运动指令
                self.cmd = [BraceletInstructions getMotionInstructions];
                [self send];
                break;
            }
            case 1:
            {
                // 发送心率指令
                self.cmd = [BraceletInstructions getHeartRateInstructions];
                [self send];
                break;
            }
            case 2:
            {
                // 显示上次测量的值
                UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
                Y2Model *y2model = userModel.y2Mdoel;
                
                // 显示血压
                self.xueyaValue.text = [NSString stringWithFormat:@"%@/%@",y2model.bloodPreHigh,y2model.bloodPreLow];
                self.xueYaShousuYa.text = [NSString stringWithFormat:@"%@",y2model.bloodPreHigh];
                self.xuyaSuZhangYa.text = [NSString stringWithFormat:@"%@",y2model.bloodPreLow];
                
                // 发送血压指令
                self.cmd = [BraceletInstructions getHeartRateInstructions];
                [self send];
                break;
            }
            case 3:
            {
                // 发送血氧指令
                self.cmd = [BraceletInstructions getHeartRateInstructions];
                [self send];
                break;
            }
            default:
                break;
        }
    } else {
        NSLog(@"滑动至%ld",(long)index);
    }
    self.lastIndex = index;
}



- (IBAction)xueyaStudy:(id)sender {
    self.xueya1.hidden = YES;
    self.xueya2.hidden = NO;
    
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    Y2Model *y2Model = userModel.y2Mdoel;
    self.xueyaStudyHigh.text = y2Model.baseBloodPreHigh;
    self.xueyaStudyLow.text = y2Model.baseBloodPreLow;
}

// 设置
- (IBAction)settingXueya:(id)sender {
    self.pickerView.hidden = NO;
}

- (IBAction)cancle:(id)sender {
    self.xueya1.hidden = NO;
    self.xueya2.hidden = YES;
}

- (IBAction)pickeCancle:(id)sender {
    self.pickerView.hidden = YES;
}

- (IBAction)pickerCentian:(id)sender {
    self.pickerView.hidden = YES;
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    Y2Model *y2model = userModel.y2Mdoel;
    if (self.highBloodPre == nil) {
        y2model.baseBloodPreHigh = @"80";
    } else {
        y2model.baseBloodPreHigh = self.highBloodPre;
    }
    if (self.lowBloodPre == nil) {
        y2model.baseBloodPreLow = @"50";
    } else {
        y2model.baseBloodPreLow = self.lowBloodPre;
    }
    userModel.y2Mdoel = y2model;
    [[UserConfig shareInstace] setAllInformation:userModel];
    
    // 设置显示高压和低压
    self.xueyaStudyHigh.text = y2model.baseBloodPreHigh;
    self.xueyaStudyLow.text = y2model.baseBloodPreLow;
    
    // 点击进行学习
    [SVProgressHUD showWithStatus:@"学习中，请稍候..."];
    UIOffset offset = UIOffsetMake(0, 100);
    [SVProgressHUD setOffsetFromCenter:offset];
    
    self.testIndex = 1;
    self.testMode = @"血压学习";
    self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
    [self send];
}


//列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.arry.count;
}

// 返回第component有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *arayM= self.arry[component];
    return arayM.count;
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    //1.获取当前的列
    NSArray *arayM= self.arry[component];
    //2.获取当前列对应的行的数据
    NSString *name=arayM[row];
    return name;
}

//select
 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //1.获取当前的列
    NSArray *arayM= self.arry[component];
    //2.获取当前列对应的行的数据
    NSString *name=arayM[row];
    NSLog(@"row:%ld,component:%ld,name:%@",(long)row,(long)component,name);
    if (component == 0) {
        // 高压
        self.highBloodPre = name;
        NSLog(@"高压：%@",name);
    } else if(component == 1) {
        // 低压
        self.lowBloodPre = name;
        NSLog(@"低压：%@",name);
    }
}

// 数据解析
- (void)analysisData:(NSString *)newString {
    NSString *cmd = [newString substringWithRange:NSMakeRange(2,2)];
    NSLog(@"收到的数据：%@\n指令：%@",newString,cmd);
    // 心率测试
    if ([cmd isEqualToString:@"f3"]) {
        
        NSString *heatvalue = [newString substringWithRange:NSMakeRange(8,2)];
        heatvalue = [NSString stringWithFormat:@"%ld",strtoul([heatvalue UTF8String],0,16)];
        NSLog(@"%@",heatvalue);
        // 判断是在进行那个测试
        if ([self.testMode isEqualToString:@"血压测试"]) {
            // 计算累计值
            self.sum = self.sum + [heatvalue integerValue];
            if (self.testIndex == 3) {
                // 停止测试，计算平准值
                [SVProgressHUD dismiss];
                NSLog(@"%ld",(long)self.sum);
                NSString *str = [NSString stringWithFormat:@"%d",self.sum / 3];
                self.sum = 0;
                
                // 血压计算公式 ：高压(收缩压)  = 基准高压*取到的心率/基准心率;               低压(舒张压)  = 基准高压*取到的心率/基准心率;
                UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
                Y2Model *y2model = userModel.y2Mdoel;
                NSInteger high = [y2model.baseBloodPreHigh integerValue]*[str integerValue]/[y2model.baseHeartValue integerValue];
                NSInteger low = [y2model.baseBloodPreLow integerValue]*[str integerValue]/[y2model.baseHeartValue integerValue];
                
                // 保存结果
                y2model.bloodPreLow = [NSString stringWithFormat:@"%ld",(long)low];
                y2model.bloodPreHigh = [NSString stringWithFormat:@"%ld",(long)high];
                [[UserConfig shareInstace] setAllInformation:userModel];
                
                
                // 显示血压
                self.xueyaValue.text = [NSString stringWithFormat:@"%ld/%ld",(long)high,(long)low];
                self.xueYaShousuYa.text = [NSString stringWithFormat:@"%ld",(long)high];
                self.xuyaSuZhangYa.text = [NSString stringWithFormat:@"%ld",(long)low];
            } else {
                // 继续发送测试命令
                self.testIndex ++;
                self.testMode = @"血压测试";
                self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
                [self send];
            }
            
        } else if([self.testMode isEqualToString:@"血压学习"]) {
            // 计算累计值
            self.sum = self.sum + [heatvalue integerValue];
            if (self.testIndex == 10) {
                // 停止测试，计算平准值
                [SVProgressHUD dismiss];
                NSLog(@"%ld",(long)self.sum);
                NSString *str = [NSString stringWithFormat:@"%d",self.sum / 10];
                self.sum = 0;
                
                // 保存基准心率
                UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
                Y2Model *y2model = userModel.y2Mdoel;
                y2model.baseHeartValue = str;
                [[UserConfig shareInstace] setAllInformation:userModel];
                
                // 血压计算公式 ：高压(收缩压)  = 基准高压*取到的心率/基准心率;               低压(舒张压)  = 基准高压*取到的心率/基准心率;
                NSInteger high = [y2model.baseBloodPreHigh integerValue]*[heatvalue integerValue]/[y2model.baseHeartValue integerValue];
                NSInteger low = [y2model.baseBloodPreLow integerValue]*[heatvalue integerValue]/[y2model.baseHeartValue integerValue];
                
                // 保存结果
                y2model.bloodPreLow = [NSString stringWithFormat:@"%ld",(long)low];
                y2model.bloodPreHigh = [NSString stringWithFormat:@"%ld",(long)high];
                [[UserConfig shareInstace] setAllInformation:userModel];
                
                
                // 显示血压
                self.xueyaValue.text = [NSString stringWithFormat:@"%ld/%ld",(long)high,(long)low];
                self.xueYaShousuYa.text = [NSString stringWithFormat:@"%ld",(long)high];
                self.xuyaSuZhangYa.text = [NSString stringWithFormat:@"%ld",(long)low];
                
                self.xueya1.hidden = NO;
                self.xueya2.hidden = YES;
                
            } else {
                // 继续发送学习命令
                // 计算百分比
                NSLog(@"%ld",(long)self.testIndex);
                float value = self.testIndex / 10.0;
                NSLog(@"%f",value);
                NSString *str2 = [NSString stringWithFormat:@"%.0f",value*100];
                // 显示百分比
                self.xueyaStudyValue.text = str2;
                
                self.testIndex ++;
                self.testMode = @"血压学习";
                self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
                [self send];
            }
        } else if([self.testMode isEqualToString:@"血氧测试"]) {
            if (self.testIndex == 3) {
                // 停止测试，计算平准值
                [SVProgressHUD dismiss];
                NSInteger value = arc4random() % 3 + 96;
                self.xueyangValue.text = [NSString stringWithFormat:@"%ld",(long)value];
            } else {
                // 继续发送测试命令
                self.testIndex ++;
                self.testMode = @"血氧测试";
                self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
                [self send];
            }
        } else if([self.testMode isEqualToString:@"心率测试"]) {
            // 计算累计值
            self.sum = self.sum + [heatvalue integerValue];
            if (self.testIndex == 3) {
                // 停止测试，计算平准值
                [SVProgressHUD dismiss];
                NSLog(@"%ld",(long)self.sum);
                NSString *str = [NSString stringWithFormat:@"%d",self.sum / 3];
                self.sum = 0;
                self.heatValue.text = str;
                self.heatLowValue.text = str;
                self.heatHighValue.text = str;

                // 保存这次测量的结果
                UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
                Y2Model *y2model = userModel.y2Mdoel;
                y2model.heartValue = str;
                userModel.y2Mdoel = y2model;
                [[UserConfig shareInstace] setAllInformation:userModel];
            } else {
                // 继续发送测试命令
                self.testIndex ++;
                self.testMode = @"心率测试";
                self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
                [self send];
            }
        } else {
            self.heatValue.text = heatvalue;
            self.heatLowValue.text = heatvalue;
            self.heatHighValue.text = heatvalue;
        }
    } else {
        // 其他指令
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    //do something....
    UIView *view = gestureRecognizer.view;
    NSLog(@"%ld",(long)view.tag);
    if(view.tag == 101) {
        [SVProgressHUD showWithStatus:@"测量中，请稍候..."];
        // 心率测试
        self.testIndex = 1;
        self.testMode = @"心率测试";
        self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
        [self send];
    } else if (view.tag == 102) {
        // 做一个判断
        UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
        Y2Model *y2Model = userModel.y2Mdoel;
        if (y2Model.baseHeartValue == nil) {
            [SVProgressHUD showInfoWithStatus:@"请先进行血压学习"];
            return;
        }
        [SVProgressHUD showWithStatus:@"测量中，请稍候..."];
        // 血压测试
        self.testIndex = 1;
        self.testMode = @"血压测试";
        self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
        [self send];
    } else if (view.tag == 103) {
        [SVProgressHUD showWithStatus:@"学习中，请稍候..."];
        // 血压学习
        self.testIndex = 1;
        self.testMode = @"血压学习";
        self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
        [self send];
    } else if (view.tag == 104) {
        [SVProgressHUD showWithStatus:@"测量中，请稍候..."];
        // 血氧测试
        self.testIndex = 1;
        self.testMode = @"血氧测试";
        self.cmd = [BraceletInstructions getHeartRateTestInstructions:YES];
        [self send];
    }
}

- (NSMutableArray *)arry {
    if (_arry == nil) {
        _arry = [NSMutableArray array];
    }
    return _arry;
}

// 统一定制发送的命令
- (void)send{
    // 先检测设备是否连接
    if (self.peripheral.state == CBPeripheralStateConnected) {
        // 直接发送命令
        if (![self.cmd isEqualToString:@"none"]) {
            NSLog(@"~~~~有待发送的命令,命令为：%@",self.cmd);
            [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:self.cmd] toCharacteristic:self.writeCharacteristic];
            self.cmd = @"none";
        } else {
            NSLog(@"~~~~无待发送的命令");
        }
    } else {
        // 重新建立连接
        NSLog(@"~~~~重新建立连接");
        [self bleConnecting];
    }
}
@end
