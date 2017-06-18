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

@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;


@property (nonatomic,strong) BleScaningDecviceModel *bleScaningDeviceModel;

+(instancetype)deviceCellWithTableView:(UITableView *)tableView;

@end
