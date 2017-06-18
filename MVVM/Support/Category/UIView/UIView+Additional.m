//
//  UIView+Additional.m
//  ZPEnterprise
//
//  Created by quange on 14-11-11.
//  Copyright (c) 2014年 深圳企大技术有限公司. All rights reserved.
//

#import "UIView+Additional.h"

@implementation UIView (Additional)

/**
 @brief 返回当前视图的视图控制器
 */
- (UIViewController *)viewController
{
    id nextResponder = [self nextResponder];
    
    while (nextResponder != nil) {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            UIViewController *vc = (UIViewController *)nextResponder;
            
            return vc;
        }
    }
    
    return nil;
}

/**
 @brief 返回当前视图的表视图
 */
- (UITableView *)presentTableView
{
    id nextResponder = [self nextResponder];
    
    while (nextResponder != nil) {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            
            UITableView *tablView = (UITableView *)nextResponder;
            
            return tablView;
        }
    }
    
    return nil;
}



@end
