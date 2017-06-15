//
//  RecordModel.h
//  MVVM
//
//  Created by 周后云 on 17/6/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
/*
 {
 "BMIIndicator": 23,
 "basalMetabolism": 1435,
 "bodyAge": 20,
 "bodyFatRatio": 29.3,
 "bodyMoisture": 51.6,
 "boneMass": 2.5,
 "id": 0,
 "identity": "39",
 "loginname": "13620208169",
 "memberid": 55522,
 "muscleRate": 0,
 "nofatWeight": 42.3,
 "protein": 0,
 "resistanceValue": 0,
 "updatetime": "2016-09-22 10:58:45.0",
 "visceralFatLevels": 10,
 "waistHipRatio": 0,
 "weight": 59.8
 }
 */

@property (nonatomic, strong) NSNumber *BMIIndicator;
@property (nonatomic, strong) NSNumber *basalMetabolism;
@property (nonatomic, strong) NSNumber *bodyAge;
@property (nonatomic, strong) NSNumber *bodyFatRatio;
@property (nonatomic, strong) NSNumber *bodyMoisture;
@property (nonatomic, strong) NSNumber *boneMass;
@property (nonatomic, strong) NSNumber *identity;
@property (nonatomic, strong) NSNumber *loginname;
@property (nonatomic, strong) NSNumber *memberid;
@property (nonatomic, strong) NSNumber *muscleRate;
@property (nonatomic, strong) NSNumber *nofatWeight;
@property (nonatomic, strong) NSNumber *protein;
@property (nonatomic, strong) NSNumber *resistanceValue;
@property (nonatomic, strong) NSString *updatetime;
@property (nonatomic, strong) NSNumber *visceralFatLevels;
@property (nonatomic, strong) NSNumber *waistHipRatio;
@property (nonatomic, strong) NSNumber *weight;

@end
