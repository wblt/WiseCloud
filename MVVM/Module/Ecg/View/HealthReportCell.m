//
//  HealthReportCell.m
//  HuiJianKang
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "HealthReportCell.h"

#import "Masonry.h"

@implementation HealthReportCell {
    UILabel *contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"dfdkfdkfd";
    [self.contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.contentView).with.offset(5);
    }];
}

- (void)setDataWithDic:(NSString *)text {
    contentLabel.text = text;
}

@end
