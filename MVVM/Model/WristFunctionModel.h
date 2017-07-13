//
//  WristFunctionModel.h
//  MVVM
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WristFunctionModel : NSObject
/*
{
    "bloodpressure": "false",
    "heartrate": "false",
    "ecg": "false",
    "sleep": "false",
    "Bloodglucose": "false",
    "position": "true",
    "sport": "false",
    "oxygen": "false",
    "status": "false",
    "temperature": "false",
    "bodyFat": "true",
    "water": "false",
    "y2bracelet": "true"
}
 */
@property(nonatomic,copy)NSString *bloodpressure;
@property(nonatomic,copy)NSString *heartrate;
@property(nonatomic,copy)NSString *ecg;
@property(nonatomic,copy)NSString *sleep;
@property(nonatomic,copy)NSString *Bloodglucose;
@property(nonatomic,copy)NSString *position;
@property(nonatomic,copy)NSString *sport;
@property(nonatomic,copy)NSString *oxygen;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *temperature;
@property(nonatomic,copy)NSString *bodyFat;
@property(nonatomic,copy)NSString *water;
@property(nonatomic,copy)NSString *y2bracelet;
@end
