//
//  CFFuncModel.m
//  CFPopViewDemo
//
//  Created by TheMoon on 16/5/18.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFFuncModel.h"

@implementation CFFuncModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
