//
//  NSString+Extend.m
//  ZPEnterprise
//
//  Created by quange on 14-11-11.
//  Copyright (c) 2014年 深圳企大技术有限公司. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

/**
 *  根据字体判断CGSize
 *
 *  @param rectSize 传进来的CGSize
 *  @param fontSize 字体的大小
 *
 *  @return CGSize
 */
- (CGSize)getSizeFromStringWithRectSize:(CGSize)rectSize fontSize:(CGFloat)fontSize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size;
}

/**
 *  判断字符串是不是为空
 */
- (BOOL)isEmptyString
{
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


@end
