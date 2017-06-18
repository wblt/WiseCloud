//
//  NetRequestClass.h
//  MVVMTest
//
//  Created by 李泽鲁 on 15/1/6.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestClass : NSObject

#pragma 监测网络的可链接性
+(BOOL)netWorkReachabilityWithURLString:(NSString *) strUrl;


+ (void)requestURL:(NSString *)urlString httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
      successBlock:(ReturnValueBlock)successBlock
      failureBlock:(FailureBlock)failureBlock;

+ (void)requestURL:(NSString *)urlString httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
      successBlock:(ReturnValueBlock)successBlock
      failureBlock:(FailureBlock)failureBlock;

@end
