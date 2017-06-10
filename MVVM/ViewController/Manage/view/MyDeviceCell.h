//
//  MyDeviceCell.h
//  HuiJianKang
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDMyDeviceCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;

@end

@class MyDeviceModel;

@interface MyDeviceCell : UITableViewCell

@property (nonatomic,strong)  MyDeviceModel *model;

@property (nonatomic, weak) id<SDMyDeviceCellDelegate> delegate;

@end
