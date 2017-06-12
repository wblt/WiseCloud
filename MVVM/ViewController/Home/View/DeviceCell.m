//
//  DeviceCell.m
//  MVVM
//
//  Created by wb on 2017/6/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

+(instancetype)deviceCellWithTableView:(UITableView *)tableView {
    static NSString *identifier= @"DeviceCell";
    DeviceCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        //如何让创建的cell加个戳
        //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DeviceCell" owner:nil options:nil]firstObject];
        NSLog(@"创建了一个cell");
        }
    return cell;
    
}

- (void)setBleScaningDeviceModel:(BleScaningDecviceModel *)bleScaningDeviceModel {
    _bleScaningDeviceModel = bleScaningDeviceModel;
    self.name.text = bleScaningDeviceModel.deviceName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
