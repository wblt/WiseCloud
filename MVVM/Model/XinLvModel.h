//
//  XinLvModel.h
//  HuiJianKang
//
//  Created by liuzhenhao on 16/5/31.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinLvModel : NSObject

@property (nonatomic, copy) NSString *devicesid;
@property (nonatomic, copy) NSString *heartrateAvg;//心率
@property (nonatomic, copy) NSString *heartrateMax;
@property (nonatomic, copy) NSString *heartrateMin;
@property (nonatomic, copy) NSString *membersid;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *sportcalorie;//运动热量
@property (nonatomic, copy) NSString *sportdistance;//运动距离
@property (nonatomic, copy) NSString *sporttep;//运动步数
@property (nonatomic, copy) NSString *sporttime;//运动时间
@property (nonatomic, copy) NSString *sleepdeep;//深度睡眠
@property (nonatomic, copy) NSString *sleeptotal;//睡眠时间
@property (nonatomic, copy) NSString *systolic;//收缩压
@property (nonatomic, copy) NSString *diastolic;//舒张压
@property (nonatomic, copy) NSString *bloodglucose;//血糖
@end
