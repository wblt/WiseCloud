//
//  UIView+Additional.h
//  ZPEnterprise
//
//  Created by quange on 14-11-11.
//  Copyright (c) 2014年 深圳企大技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additional)

/**
 @brief 返回当前视图的视图控制器
 */
- (UIViewController *)viewController;

/**
 @brief 返回当前视图的表视图
 */
- (UITableView *)presentTableView;

@end
