//
//  LocationModel.h
//  HuiJianKang
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

/*
 "address": "广东省深圳市南山区丽山路99(平山小学西南47米)",
 "devicesid": "",
 "id": "",
 "latitude": "22.59298",
 "longitude": "113.970634",
 "membersid": "",
 "updatetime": "2016-08-11 11:39:51.0"
 */
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *devicesid;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *membersid;
@property (nonatomic,copy) NSString *updatetime;

@end
