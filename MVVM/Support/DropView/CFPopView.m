//
//  CFPopView.m
//  CFPopViewDemo
//
//  Created by TheMoon on 16/3/31.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFPopView.h"
#import "CFFuncTableViewCell.h"
#import "CFFuncModel.h"
/**
 *  设置颜色RGB值
 */
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

@interface CFPopView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static const CGFloat everyW = width;
static const CGFloat everyH = rowH;
// tableView的最小高度为10，会随着cell个数的增加改变
static CGFloat height = 10;
static const CGFloat maxH = 10 + everyH * 5;
@implementation CFPopView
 

+ (instancetype)popViewWithFuncModels:(NSArray *)funcModels{
    CFPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"CFPopView" owner:self options:nil].lastObject;
    popView.funcModels = [@[] mutableCopy];
    if (funcModels && funcModels.count) {
        height = 10 + everyH * funcModels.count;
        popView.funcModels = [funcModels mutableCopy];
    }
    // 最大高度为4个选项的高度
    height = height > maxH ? maxH : height;
    // 设置弹出视图的位置
    popView.frame = CGRectMake(kScreenWidth - everyW - 40, 64, everyW, height);
    [popView createUIWithCount:popView.funcModels.count];
    //popView.bgView.backgroundColor = [UIColor greenColor];
    return popView;
}

+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts{
    CFPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"CFPopView" owner:self options:nil].lastObject;
    popView.funcModels = [@[] mutableCopy];
    if (funcDicts && funcDicts.count) {
        for (NSDictionary *dict in funcDicts) {
            CFFuncModel *funcModel = [[CFFuncModel alloc] initWithDict:dict];
            [popView.funcModels addObject:funcModel];
        }
        height = 10 + everyH * popView.funcModels.count;
        
    }
    // 最大高度为4个选项的高度
    height = height > maxH ? maxH : height;
    // 设置弹出视图的位置
    popView.frame = CGRectMake(kScreenWidth - everyW - 20 , 64, everyW, height);
    [popView createUIWithCount:popView.funcModels.count];
    //popView.bgView.backgroundColor = [UIColor greenColor];
    return popView;
}
- (void)createUIWithCount:(NSInteger)count{
    
    self.tableView.layer.cornerRadius = 10;
    self.tableView.rowHeight = everyH;
    // 大于4项可以滚动
    self.tableView.scrollEnabled = count >4 ? YES : NO;
    //self.bgView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = RGBCOLOR(37, 206, 184, 1);
    
    // 画三角形
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width - 25, 10)];
    [path addLineToPoint:CGPointMake(width - 20, 2)];
    [path addLineToPoint:CGPointMake(width - 15, 10)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 颜色设置和cell颜色一样
    layer.fillColor = RGBCOLOR(37, 206, 184, 1).CGColor;
    layer.strokeColor = RGBCOLOR(37, 206, 184, 1).CGColor;
    layer.path = path.CGPath;
    [self.bgView.layer addSublayer:layer];
    
}


- (void)showInKeyWindow{
    _isShow = YES;
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissFromKeyWindow{
    _isShow = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.transform = CGAffineTransformTranslate(self.transform, 40, -64);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"funcCell";
    CFFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CFFuncTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (!self.funcModels.count) {
        return cell;
    }
    
    cell.funcModel = self.funcModels[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CFFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    //NSLog(@"%ld", indexPath.row);

    if(self.myFuncBlock){
        self.myFuncBlock (indexPath.row);
    }
    
    //[self dismissFromKeyWindow];
}



@end
