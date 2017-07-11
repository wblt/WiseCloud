//
//  LocationModel.m
//  HuiJianKang
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

//解决重命名
+(instancetype)objectWithKeyValues:(id)keyValues {
    NSDictionary *dic = (NSDictionary *)keyValues;
    NSString *sid = dic[@"id"];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mudic removeObjectForKey:@"id"];
    [mudic setObject:sid forKey:@"Id"];
    return [self objectWithKeyValues:mudic error:nil];
}

@end
