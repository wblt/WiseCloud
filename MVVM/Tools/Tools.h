//
//  Tools.h
//  MVVMTest
//
//  Created by Mr.LuDashi on 2017/5/15.
//  Copyright © 2017年 李泽鲁. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"

@interface Tools : NSObject

/**
 计算固定宽度的文本显示高度

 @param text 文本
 @param width 显示宽度
 @param fontSize 显示字体
 @return 文本显示高度
 */
+ (CGFloat)countTextHeight:(NSString *)text
                     width:(CGFloat) width
                      font:(CGFloat) fontSize;

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value andWidth:(float)width;


// data 转16进制数据
+ (NSString *)convertDataToHexStr:(NSData *)data;

// 16进制数据转byte
+ (NSData*)hexToBytes:(NSString *)str;

//16进制转10进制
+ (CGFloat) numberHexString:(NSString *)aHexString;


@end
