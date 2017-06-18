//
//  MyDeviceCell.m
//  HuiJianKang
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "MyDeviceCell.h"
#import "Masonry.h"
#import "MyDeviceModel.h"

@implementation MyDeviceCell {
    UILabel *nameLabel;
    UILabel *numberLabel;
    UILabel *flageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    nameLabel = [[UILabel alloc] init];
    [nameLabel sizeToFit];
    nameLabel.text = @"设备名称";
    [self.contentView addSubview:nameLabel];
    
    UIButton *deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletButton setTitle:@"解绑" forState:UIControlStateNormal];
    [deletButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    deletButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [deletButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deletButton];
    
    numberLabel = [[UILabel alloc] init];
    [numberLabel sizeToFit];
    numberLabel.text = @"手表设备号";
    [self.contentView addSubview:numberLabel];
    
    flageLabel = [[UILabel alloc] init];
    [flageLabel sizeToFit];
    flageLabel.text = @"此设备是否是默认设备";
    [self.contentView addSubview:flageLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
    }];
    
    [deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(nameLabel);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10);
    }];
    
    [flageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(numberLabel.mas_bottom).with.offset(10);
    }];
    
}

- (void)setModel:(MyDeviceModel *)model {
    _model = model;
    
    nameLabel.text = [NSString stringWithFormat:@"名称:%@",model.weixinnickname];
    
    numberLabel.text = [NSString stringWithFormat:@"手表设备号:%@",model.deviceid];
    
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];

    if ([model.deviceid isEqualToString:userModel.defaultDeVice]) {
        flageLabel.text = @"此设备是否是默认设备:是";
    }
    else {
        flageLabel.text = @"此设备是否是默认设备:否";
    }
}

- (void)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
        [self.delegate didClickLikeButtonInCell:self];
    }
}

@end
