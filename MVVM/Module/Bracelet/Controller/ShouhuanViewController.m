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
@end

@implementation ShouhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
         if (self.firstFlag == NO) {
             // 首次发送获取运动的数据
             NSString *str = [BraceletInstructions getUnbundingInstructions];
             NSLog(@"运动数据：%@",str);
             [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
             self.firstFlag = YES;
         }
         
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
                NSString *str = [BraceletInstructions getMotionInstructions];
                NSLog(@"运动数据：%@",str);
                [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
                
                break;
            }
            case 1:
            {
                // 发送心率指令
                NSString *str = [BraceletInstructions getHeartRateInstructions];
                NSLog(@"心率数据：%@",str);
                [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
                break;
            }
            case 2:
            {
                
                // 发送血压指令
                NSString *str = [BraceletInstructions getHeartRateInstructions];
                NSLog(@"心率数据：%@",str);
                [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
                
                break;
            }
            case 3:
            {
                // 发送血氧指令
                NSString *str = [BraceletInstructions getHeartRateInstructions];
                NSLog(@"心率数据：%@",str);
                [self.ble peripheral:self.peripheral writeData:[Tools hexToBytes:str] toCharacteristic:self.writeCharacteristic];
                
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

// 数据解析
- (void)analysisData:(NSString *)newString {
    NSString *cmd = [newString substringWithRange:NSMakeRange(2,2)];
    NSLog(@"收到的数据：%@\n指令：%@",newString,cmd);
    if ([cmd isEqualToString:@"f3"]) {
        // 判断是在进行那个测试
        if ([self.testMode isEqualToString:@"血压测试"]) {
            
        } else if([self.testMode isEqualToString:@"血压学习"]) {
            
        } else if([self.testMode isEqualToString:@"血氧测试"]) {
            
        } else if([self.testMode isEqualToString:@"心率测试"]) {
            
        } else {
            NSString *heatvalue = [newString substringWithRange:NSMakeRange(8,2)];
            heatvalue = [NSString stringWithFormat:@"%ld",strtoul([heatvalue UTF8String],0,16)];
            NSLog(@"%@",heatvalue);
            self.heatValue.text = heatvalue;
            self.heatLowValue.text = heatvalue;
            self.heatHighValue.text = heatvalue;
        }
    } else {
        
        
    }
}

- (IBAction)xueyaStudy:(id)sender {
    self.xueya1.hidden = YES;
    self.xueya2.hidden = NO;
}

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

}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    //do something....
//    [SVProgressHUD showWithStatus:@"测量中，请稍候..."];
    UIView *view = gestureRecognizer.view;
    NSLog(@"%ld",(long)view.tag);
    if(view.tag == 101) {
        // 心率
        
    } else if (view.tag == 102) {
        // 血压测试
        
        
    } else if (view.tag == 103) {
        // 血压学习
        
        
    } else if (view.tag == 104) {
        // 血氧测试

    }
}

- (NSMutableArray *)arry {
    if (_arry == nil) {
        _arry = [NSMutableArray array];
    }
    return _arry;
}
@end
