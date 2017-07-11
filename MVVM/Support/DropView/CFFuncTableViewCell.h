//
//  CFFuncTableViewCell.h
//  CFPopViewDemo
//
//  Created by TheMoon on 16/3/31.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFFuncModel;
// cell的高度和宽度
static const CGFloat width = 200;
static const CGFloat rowH = 50;
@interface CFFuncTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (nonatomic, strong) CFFuncModel *funcModel;
@end
