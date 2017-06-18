//
//  BodyFatCell.h
//  HuiJianKang
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BodyFatModel;

@interface BodyFatCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *unitLabel;

@property (nonatomic,strong) UILabel *resultLabel;


@property (nonatomic,strong) BodyFatModel *model;

@end
