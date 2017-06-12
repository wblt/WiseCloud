//
//  CustomFooterBar.m
//  HuiJianKang
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "CustomFooterBar.h"
#import "Masonry.h"

@implementation CustomFooterBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button1];
    [button1 setTitle:@"干性" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    button1.backgroundColor = [UIColor colorWithRed:41/255.0 green:206/255.0 blue:180/255.0 alpha:1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.25);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-20);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"湿润" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    button3.backgroundColor = [UIColor colorWithRed:3/255.0 green:54/255.0 blue:229/255.0 alpha:1];
    [self addSubview:button3];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"中性" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    button2.backgroundColor = [UIColor colorWithRed:23/255.0 green:174/255.0 blue:240/255.0 alpha:1];
    [self addSubview:button2];
    
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right);
        make.right.equalTo(self);
        make.width.equalTo(button2.mas_width);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-20);;
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button1.mas_right);
        make.right.equalTo(button3.mas_left);
        make.width.equalTo(button3.mas_width);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-20);;
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"20%";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:14];
    [self addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"30%";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:14];
    [self addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button1.mas_right);
        make.bottom.equalTo(self);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"45%";
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:14];
    [self addSubview:label3];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button2.mas_right);
        make.bottom.equalTo(self);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"60%";
    label4.textColor = [UIColor whiteColor];
    label4.font = [UIFont systemFontOfSize:14];
    [self addSubview:label4];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button3.mas_right);
        make.bottom.equalTo(self);
    }];

}

@end
