//
//  Config.h
//  MVVMTest
//
//  Created by 李泽鲁 on 15/1/6.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#ifndef MVVMTest_Config_h
#define MVVMTest_Config_h

#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//请求公共微博的网络接口
#if 1

#define BaseUrl @"http://115.29.5.227/hiwatchclient/"

#else

#define BaseUrl @"http://101.201.80.234/watchclient/"

#endif

//屏幕的宽度，屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

#endif
