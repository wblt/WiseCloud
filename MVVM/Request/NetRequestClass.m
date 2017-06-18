//
//  NetRequestClass.m
//  MVVMTest
//
//  Created by 李泽鲁 on 15/1/6.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import "NetRequestClass.h"

@implementation NetRequestClass
/**
 监测网络的可链接性

 @param strUrl URL地址
 @return 是否可达
 */
+(BOOL)netWorkReachabilityWithURLString:(NSString *) strUrl {
    __block BOOL netState = YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            case AFNetworkReachabilityStatusUnknown:
                netState = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netState = YES;
                break;
           
            default:
                break;
        }
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return netState;
}


+ (void)requestURL:(NSString *)urlString httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
      successBlock:(ReturnValueBlock)successBlock
      failureBlock:(FailureBlock)failureBlock {
    // 1 拼接地址
    //utf8编码
    NSString *ut8Str = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *requestURL = [BaseUrl stringByAppendingString:ut8Str];
    
    NSURL *url = [NSURL URLWithString:requestURL];
    //2.创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话（这里使用了一个全局会话）
    NSURLSession *session = [NSURLSession sharedSession];
    //4.通过会话创建任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (!error) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            //上传成功
                                                            if (successBlock) {
                                                                successBlock(data);
                                                            }
                                                            
                                                            
                                                        });
                                                        
                                                    }else{
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            //上传失败
                                                            if (failureBlock) {
                                                                failureBlock(error);
                                                            }
                                                            
                                                        });
                                                    }
                                                }];
    //5.每一个任务默认都是挂起的，需要调用 resume 方法启动任务
    [dataTask resume];
    
}

+ (void)requestURL:(NSString *)urlString httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
      successBlock:(ReturnValueBlock)successBlock
      failureBlock:(FailureBlock)failureBlock {
    
    // 1 拼接地址
    //utf8编码
    NSString *ut8Str = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *requestURL;
    if (files == nil) {
        requestURL = [BaseUrl stringByAppendingString:ut8Str];
    }else {
        requestURL = [@"http://101.201.80.234/platform/" stringByAppendingString:ut8Str];
    }
    // 3. 构造一个操作对象的管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];//响应
    // 这里要注意一下，不同的接口，我们在这里拼接一下可能会出错
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png", nil];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //请求
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        [manager GET:requestURL parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
            //请求进度
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            if (successBlock) {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //上传失败
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        
    }else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        
        [manager POST:requestURL parameters:parmas progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //上传失败
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

@end
