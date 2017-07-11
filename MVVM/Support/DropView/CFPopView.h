//
//  CFPopView.h
//  CFPopViewDemo
//
//  Created by TheMoon on 16/3/31.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FuncBlock)(NSInteger index);

@interface CFPopView : UIView
/**
 *  里面存储funcModel对象
 */
@property (nonatomic, strong) NSMutableArray *funcModels;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) FuncBlock myFuncBlock;

// 功能模型数组
+ (instancetype)popViewWithFuncModels:(NSArray *)funcModels;
// 功能字典数组
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts;
- (void)showInKeyWindow;
- (void)dismissFromKeyWindow;

@end
