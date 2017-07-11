//
//  BodyFatCell.m
//  HuiJianKang
//
//  Created by mac on 16/6/26.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "BodyFatCell.h"
#import "Masonry.h"
#import "BodyFatModel.h"

@implementation BodyFatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self setup];
        
    }
    return self;
}

- (void)setup {
    
    //图标
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"wenduji"];
    [self.contentView addSubview:_imgView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"去脂体脂";
    [self.contentView addSubview:_nameLabel];
    
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.text = @"-";
    [self.contentView addSubview:_resultLabel];
    
    _unitLabel
    = [[UILabel alloc ] init];
    _unitLabel.textAlignment = NSTextAlignmentRight;
    _unitLabel.text = @"kg";
    [self.contentView addSubview:_unitLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).with.offset(10);
        make.centerY.equalTo(_imgView);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(50);
    }];
    
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_unitLabel.mas_left).with.offset(-15);
        make.centerY.equalTo(_unitLabel);
    }];

}

- (void)setModel:(BodyFatModel *)model {
    
    _model = model;
    

}


@end
