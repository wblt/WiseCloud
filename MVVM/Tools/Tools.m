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




/**
 * 读取用户信息
 *
 */
+ (UserModel *) readUserModelFromLocal {
    
    return nil;
}

/**
 * 写入用户信息
 *
 */
+ (void) writeUserModelToLocal:(UserModel *)userModel {
    
}
@end
