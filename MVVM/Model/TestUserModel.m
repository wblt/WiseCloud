//
//  TestUserModel.m
//  HuiJianKang
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "TestUserModel.h"

@implementation TestUserModel

MJCodingImplementation // MJ归档协议

+(instancetype)objectWithKeyValues:(id)keyValues {
    NSDictionary *dic = (NSDictionary *)keyValues;
    NSString *careID = dic[@"id"];
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mudic removeObjectForKey:@"id"];
    [mudic setObject:careID forKey:@"careID"];
    return [self objectWithKeyValues:mudic error:nil];
}

@end
