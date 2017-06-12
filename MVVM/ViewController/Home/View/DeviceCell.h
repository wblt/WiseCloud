//
//  DeviceCell.h
//  MVVM
//
//  Created by wb on 2017/6/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BleScaningDecviceModel.h"

@interface DeviceCell : UITableViewCell

@property (nonatomic,strong) BleScaningDecviceModel *bleScaningDeviceModel;

+(instancetype)deviceCellWithTableView:(UITableView *)tableView;

@end
