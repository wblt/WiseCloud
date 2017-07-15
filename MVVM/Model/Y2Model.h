//
//  Y2Model.h
//  MVVM
//
//  Created by wb on 2017/7/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2Model : NSObject

// 测量的心率值
@property(nonatomic,copy) NSString *heartValue;

// 收缩压
@property(nonatomic,copy) NSString *bloodPreHigh;

// 舒张压
@property(nonatomic,copy) NSString *bloodPreLow;

// 基准高压
@property(nonatomic,copy) NSString *baseBloodPreHigh;

// 基准低压
@property(nonatomic,copy) NSString *baseBloodPreLow;

// 基准心率
@property(nonatomic,copy) NSString *baseHeartValue;

// 血氧
@property(nonatomic,copy) NSString *xueyangValue;



@end
