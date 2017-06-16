//
//  BodyFatModel.h
//  HuiJianKang
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyFatModel : NSObject
/*
 {
 bmi = "9.7";
 bmr = "0.0";
 bodyfat = "0.0";
 bone = "0.0";
 "measure_time" = "2016-07-04 12:25:18";
 muscle = "0.0";
 protein = "0.0";
 subfat = "0.0";
 "user_id" = pyf;
 visfat = 0;
 water = "0.0";
 weight = "30.00";
 }
 */
@property (nonatomic,copy) NSString *bmi;
@property (nonatomic,copy) NSString *bmr;
@property (nonatomic,copy) NSString *bodyfat;
@property (nonatomic,copy) NSString *bone;
@property (nonatomic,copy) NSString *measure_time;
@property (nonatomic,copy) NSString *muscle;
@property (nonatomic,copy) NSString *protein;
@property (nonatomic,copy) NSString *subfat;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *visfat;
@property (nonatomic,copy) NSString *water;
@property (nonatomic,copy) NSString *weight;
@end
