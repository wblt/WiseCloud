//
//  UserModel.h
//  TaTaTa
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 wb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestUserModel.h"

#import "Y2Model.h"

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *userPhoneNum;

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *userPassword;

@property (nonatomic,strong) NSMutableArray *deviceArray;

@property (nonatomic,copy) NSString *defaultDeVice;

@property (nonatomic,strong) TestUserModel *testUserModel;

@property (nonatomic,strong) Y2Model *y2Mdoel;
@end
