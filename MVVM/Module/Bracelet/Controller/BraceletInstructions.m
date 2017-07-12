//
//  BraceletInstructions.m
//  MVVM
//
//  Created by wb on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BraceletInstructions.h"

/**
 * 包头-设备识别
 */
#define INSTRUCTIONS_HEAD @"A9"
/**	时间设置	0x01 **/
#define  INSTRUCTIONS_TIME @"01"
/**闹钟设置	0x02 */
#define INSTRUCTIONS_ALARM_CLOCK @"02"
/***设备绑定命令	0x32*/
#define INSTRUCTIONS_BINDING @"32"
/***设备绑定应答	0x33*/
#define INSTRUCTIONS_BINDING_RETURN @"33"
/***登入请求	0x34*/
#define INSTRUCTIONS_LOGIN @"34"
/***登入响应	0x35*/
#define INSTRUCTIONS_LOGIN_RETURN @"35"
/***解除绑定命令	0x0C*/
#define INSTRUCTIONS_UNBUNDING @"0C"
/***解除绑定回应	0x0D*/
#define INSTRUCTIONS_UNBUNDING_RETURN @"0D"
/***运动目标设置	0x03*/
#define INSTRUCTIONS_MOVING_TARGET @"03"
/***用户信息设置	0x04*/
#define INSTRUCTIONS_USER_INFO @"04"
/***	防丢设置	0x05*/
#define INSTRUCTIONS_ANTI_LOST @"05"
/***	久坐设置	0x06*/
#define INSTRUCTIONS_SEDENTARY @"06"
/***自动睡眠设置	0x07*/
#define INSTRUCTIONS_AUTO_SLEEP @"07"
/***设备电量请求	0x08*/
#define INSTRUCTIONS_ELECTRICITY @"08"
/***设备电量返回	0x09*/
#define INSTRUCTIONS_ELECTRICITY_RETURN @"09"
/***系统用户设置	0x0A*/
#define INSTRUCTIONS_SYSTEM_USER @"0A"
/***天气推送	0x0B*/
#define INSTRUCTIONS_WEATHER_PUSH @"0B"
/***查找手环	0x0E*/
#define INSTRUCTIONS_FIND_BRACELET @"0E"
/***	远程控制	0x0F*/
#define INSTRUCTIONS_REMOTE_CONTROL @"0F"
/***来电提醒	0x10*/
#define INSTRUCTIONS_CALL @"10"
/***短信提醒	0x11*/
#define INSTRUCTIONS_SHORT_MESSAGE @"11"
/***QQ提醒	0x12*/
#define INSTRUCTIONS_QQ @"12"
/***微信提醒	0x13*/
#define INSTRUCTIONS_WECHAT @"13"
/**推送设置	0x14*/
#define INSTRUCTIONS_PUSH_SET @"14"
/***勿扰模式	0x15*/
#define INSTRUCTIONS_DO_NOT_DISTURD @"15"
/***提醒模式	0x16*/
#define INSTRUCTIONS_REMIND @"16"
/***手势智控	0x17*/
#define INSTRUCTIONS_GESTURE_CONTROL @"17"
/***配置信息同步	0x18*/
#define INSTRUCTIONS_CONFIG_MSG_SYNC @"18"
/***推送消息	0x19*/
#define INSTRUCTIONS_PUSH_MSG @"19"
/***手机语言更新	0x1A*/
#define INSTRUCTIONS_LANGUAGE_UPDATE @"1A"
/***APP同步气压紫外线温度	0x1B*/
#define INSTRUCTIONS_ENVIRONMENTEL_SYNC @"1B"
/***拍照开关	0x1C*/
#define INSTRUCTIONS_CAMERA_SWITCH  @"1C"
/***固件升级启动	0x1D*/
#define INSTRUCTIONS_FIRMWARE_UP_STARTS @"1D"
/***固件升级回应	0x1E*/
#define INSTRUCTIONS_FIRMWARE_UP_RETURN @"1E"
/***固件升级状态	0x1F*/
#define INSTRUCTIONS_FIRMWARE_UP_STATE @"1F"
/***运动数据请求	0x20*/
#define INSTRUCTIONS_MOTION @"20"
/***	运动数据返回	0x21*/
#define INSTRUCTIONS_MOTION_RETURN @"21"
/***睡眠数据请求	0x22*/
#define INSTRUCTIONS_SLEEP @"22"
/***睡眠数据返回	0x23*/
#define INSTRUCTIONS_SLEEP_RETURN @"23"
/***运动数据同步设置	0x24*/
#define INSTRUCTIONS_MOTION_SYNC_SET @"24"
/***历史数据同步指示	0x25*/
#define INSTRUCTIONS_HOISTORY_MOTION_SYNC @"25"
/***心率数据请求	0x26*/
#define INSTRUCTIONS_HEART_RATE @"26"
/***心率数据返回	0x27*/
#define INSTRUCTIONS_HEART_RATE_RETURN @"27"
/***气压数据请求	0x28*/
#define INSTRUCTIONS_PRESSURE @"28"
/***气压数据返回	0x29*/
#define INSTRUCTIONS_PRESSURE_RETURN @"29";
/***紫外线数据请求	0x2A*/
#define INSTRUCTIONS_ULTRAVIOLET_RAYS @"2A"
/***紫外线数据返回	0x2B*/
#define INSTRUCTIONS_ULTRAVIOLET_RAYS_RETURN @"2B"
/***自动测试心率	0x2C*/
#define INSTRUCTIONS_AUTO_HEART_RATE @"2C"
/***固件升级命令	0x30*/
#define INSTRUCTIONS_FIRMWARE_UP @"30"
/***固件版本信息	0x31*/
#define INSTRUCTIONS_FIRMWARE_MSG @"31"
/***实时同步数据	0x36*/
#define INSTRUCTIONS_SYNC_DATA @"36"
/***当天运动校准	0x37*/
#define INSTRUCTIONS_DAY_MOTION @"37"
/***断开蓝牙指示	0x38*/
#define INSTRUCTIONS_DISCONNECT_BLE @"38"
/***横竖显示 	0x39*/
#define INSTRUCTIONS_ANYWAY_DISPLAY @"39"
/***喝水提醒设置	0x3a*/
#define INSTRUCTIONS_DRINK_WATER @"3A"
/***屏幕测试	0xf0*/
#define INSTRUCTIONS_SCREEN_TEST @"F0"
/***马达测试	0xf1*/
#define INSTRUCTIONS_MOTOR_TEST @"F1"
/***计步器测试	0xf2*/
#define INSTRUCTIONS_PEDOMETER_TEST @"F2"
/***心率测试	0xf3*/
#define INSTRUCTIONS_HEART_RATE_TEST @"F3"
/***Flahs测试	0xf4*/
#define INSTRUCTIONS_FLAHS_TEST @"F4"
/***关机命令	0xf5*/
#define INSTRUCTIONS_POWER_CLOSE @"F5"
/***解绑命令	0xf6*/
#define INSTRUCTIONS_UNBUNDING_SYSTEM @"F6"
/***重启命令	0xf7*/
#define INSTRUCTIONS_RESTART @"F7"
/***请求睡眠汇总数据发送到厂商服务器	0x44*/
#define INSTRUCTIONS_SEND_SLEEP_DATA @"44"

/***请求手环主动间隔15s发运动汇总数据到厂商服务器	0x48*/
#define  INSTRUCTIONS_SEND_SLEEP_DATA_TIME @"48"
/***连接微信成功回应	0xC0*/
#define INSTRUCTIONS_CONNECT_WECHAT @"C0"
/***发送运动历史数据到微信	0xA8*/
#define INSTRUCTIONS_SEND_HISTORY_MOTION_WECHAT @"A8"

/***实时同步数据-关闭*/
#define REAL_TIME_SYNC_CLOSE @"00"
/***实时同步数据-运动*/
#define REAL_TIME_SYNC_MOTION @"01"
/***实时同步数据-睡眠*/
#define REAL_TIME_SYNC_SLEEP @"02"
/***实时同步数据-心率*/
#define REAL_TIME_SYNC_HEART_RATE @"03"
/***实时同步数据-气压*/
#define REAL_TIME_SYNC_PRESSURE @"04"

@implementation BraceletInstructions
/**获取0长度的命令
 * @param instructions 命令
 */
+(NSString *)getZeroLenthInstructions:(NSString *)instructions {
    NSString *str = [INSTRUCTIONS_HEAD stringByAppendingString:instructions];
    str = [str stringByAppendingString:@"00"];
    str = [str stringByAppendingString:@"00"];
    str = [str stringByAppendingString:[self calculationCRC:str]];
    [self proofreadingCRC:str];
    return str;
}

/**获取1长度的命令
 * @param instructions 命令
 **/
+(NSString *)getOneLenthInstructions:(NSString *)instructions withData:(NSString *)data {
    NSString *str = [INSTRUCTIONS_HEAD stringByAppendingString:instructions];
    str = [str stringByAppendingString:@"00"];
    str = [str stringByAppendingString:@"01"];
    str = [str stringByAppendingString:data];
    str = [str stringByAppendingString:[self calculationCRC:str]];
    [self proofreadingCRC:str];
    return str;
}

/**计算校验码
 **/
+(NSString *)calculationCRC:(NSString *)val{
    NSData* bytes = [Tools hexToBytes:val];
    Byte *myByte = (Byte *)[bytes bytes];
    NSString *crc = @"";
    if(myByte != nil)
    {
        Byte bb = myByte[0];
        
        Byte *resultByte = (Byte *)[bytes bytes];
        for(int i=0;i<[bytes length];i++) {
            printf("testByteFF02[%d] = %d\n",i,resultByte[i]);
        }
        
        for(int i = 1;i<sizeof(myByte);i++)
        {
            bb += myByte[i];
            printf("bb:%d,%d",bb,myByte[i]);
        }
        int s =  (bb&0xFF);
        crc = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",s]];
    }
    if(crc.length<2)
    {
        crc = [@"0" stringByAppendingString:crc];
    }
    return crc;
}

/**计算校验码
 */
+(NSString *)calculationCRC:(NSString *)val withData:(NSData *)adata{
    NSData* bdata = [Tools hexToBytes:val];
    NSString *crc = @"";
    NSMutableData *mData = [[NSMutableData alloc] init];
    [mData appendData:adata];
    [mData appendData:bdata];
    Byte *myByte = (Byte *)[mData bytes];
    if(myByte!=nil)
    {
        Byte bb = myByte[0];
        for(int i = 1;i<sizeof(myByte);i++)
        {
            bb+=myByte[i];
        }
        int s =  (bb&0xFF);
        crc = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",s]];
    }
    if(crc.length<2)
    {
        crc = [@"0" stringByAppendingString:crc];
    }
    return crc;
}


/**校对校验码
 */
+(BOOL)proofreadingCRC:(NSString *)val{
    NSString *s = [val substringWithRange:NSMakeRange(0,(val.length - 2))];
    NSString *crc = [val substringFromIndex:(val.length -2)];
    NSString *temp = @"";
    NSData* data = [Tools hexToBytes:s];
    Byte *myByte = (Byte *)[data bytes];
    if(myByte!=nil)
    {
        Byte bb =myByte[0];
        for(int i = 1;i<sizeof(myByte);i++)
        {
            bb+=myByte[i];
        }
        int num =  (bb&0xFF);
        temp = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",num]];
        if(temp.length<2)
        {
            temp = [@"0" stringByAppendingString:temp];
        }
    }
    NSLog(@"校对一下:%@\ncrc:%@\n%@",val,temp,crc);
    if([crc isEqualToString:temp])
    {
        return true;
    }
    return false;
}

/**获取运动指令
 */
+(NSString *)getMotionInstructions {
    return [self getZeroLenthInstructions:INSTRUCTIONS_MOTION];
}

/**获取心率指令
  */
+(NSString *)getHeartRateInstructions {
    return [self getZeroLenthInstructions:INSTRUCTIONS_HEART_RATE];
}

/**获取心率测试指令
 */
+(NSString *)getHeartRateTestInstructions:(BOOL)state {
    NSString *s = @"01";
    if(!state)
    {
        s = @"00";
    }
    return [self getOneLenthInstructions:INSTRUCTIONS_HEART_RATE_TEST withData:s];
}

/**获取计步器测试指令
 */
+(NSString *)getPedometerTestInstructions:(BOOL)state{
    NSString *s = @"01";
    if(!state)
    {
        s = @"00";
    }
    return [self getOneLenthInstructions:INSTRUCTIONS_PEDOMETER_TEST withData:s];
}



@end
