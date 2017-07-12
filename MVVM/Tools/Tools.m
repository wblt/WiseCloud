//
//  Tools.m
//  MVVMTest
//
//  Created by Mr.LuDashi on 2017/5/15.
//  Copyright © 2017年 李泽鲁. All rights reserved.
//

#import "Tools.h"

@implementation Tools
/**
 计算博文高度
 @return 高度
 */
+ (CGFloat)countTextHeight:(NSString *)text
                     width:(CGFloat) width
                      font:(CGFloat) fontSize
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - width, CGFLOAT_MAX) options:options context:nil];
    return rect.size.height;
}

/*
@method 获取指定宽度width,字体大小fontSize,字符串value的高度
@param value 待计算的字符串
@param fontSize 字体的大小
@param Width 限制字符串显示区域的宽度
@result float 返回的高度
*/
+ (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}




+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange,BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) &0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

+ (NSData*)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

// 16进制转10进制
+ (CGFloat) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return 0.0;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return [hexNumber floatValue];
}



@end
