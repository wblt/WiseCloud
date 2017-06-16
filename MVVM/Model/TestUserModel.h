//
//  TestUserModel.h
//  HuiJianKang
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestUserModel : NSObject

/*
 {
 "dateofbirth": "1996-07-12",
 "height": 158,
 "hip": 99,
 "id": "39",
 "name": "赖",
 "phone": "13620208169",
 "sex": 1,
 "updatetime": "2016-07-12",
 "waist": 98
 }
 */

@property (nonatomic,copy) NSString *dateofbirth;

@property (nonatomic,copy) NSString *height;

@property (nonatomic,copy) NSString *hip;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *updatetime;

@property (nonatomic,copy) NSString *waist;

@property (nonatomic,copy) NSString *careID;



@end
