//
//  CFFuncTableViewCell.m
//  CFPopViewDemo
//
//  Created by TheMoon on 16/3/31.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFFuncTableViewCell.h"
#import "CFFuncModel.h"


@implementation CFFuncTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, rowH - 0.5)];
    [path addLineToPoint:CGPointMake(width - 10, rowH - 0.5)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    [self.layer addSublayer:layer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFuncModel:(CFFuncModel *)funcModel{
    _funcModel = funcModel;
    self.titleLabel.text = _funcModel.title;
    self.iconImgView.image = [UIImage imageNamed:_funcModel.iconName];
}

@end
