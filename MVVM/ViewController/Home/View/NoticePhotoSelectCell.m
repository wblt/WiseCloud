//
//  NoticePhotoSelectCell.m
//  ThankYou
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//

#import "NoticePhotoSelectCell.h"

#import "Masonry.h"

@implementation NoticePhotoSelectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    self.clipsToBounds = YES;
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"del_ico-1"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imageView).with.offset(3);
        make.top.equalTo(_imageView).with.offset(-5);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];

}



- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

#pragma mark - 关闭点击函数
- (void)closeButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photoCellRemovePhotoBtnClickForCell:)]) {
        [self.delegate photoCellRemovePhotoBtnClickForCell:self];
    }
}
@end
