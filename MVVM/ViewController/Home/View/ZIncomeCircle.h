//
//  ZTodayIncomCircle.h
//  DrawCircle学习
//
//  Created by cz. on 15/9/6.
//  Copyright (c) 2015年 CZDomain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZIncomeHeadType) {
    ZIncomeHeadTypeToday,//今日收益
    ZIncomeHeadTypeAdv, //广告收益
    ZIncomeHeadTypeDepth //深度任务
};

@interface ZIncomeCircle : UIView

@property (nonatomic,assign) ZIncomeHeadType headType;
@property (nonatomic,assign) CGFloat progress;//（0-1 取值）

@property (nonatomic,assign) BOOL isIphone4;
@property (nonatomic, strong) UIColor *backLineColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic,assign) BOOL isHome;

@end
