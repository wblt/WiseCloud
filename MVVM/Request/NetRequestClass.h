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

#pragma POST请求
+(void)NetRequestPOSTWithRequestURL:(NSString *) requestURLString
                      WithParameter:(NSDictionary *) parameter
               WithReturnValeuBlock:(ReturnValueBlock) block
                   WithFailureBlock:(FailureBlock) failureBlock;

#pragma GET请求
+(void)NetRequestGETWithRequestURL:(NSString *) requestURLString
                     WithParameter:(NSDictionary *) parameter
              WithReturnValeuBlock:(ReturnValueBlock) block
                  WithFailureBlock:(FailureBlock) failureBlock;

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
