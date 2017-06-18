//
//  RegisterViewController.h
//  HJKHiWatch
//
//  Created by AirTops on 15/11/27.
//  Copyright © 2015年 cn.hi-watch. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RegisterBackBlock)(NSString *,NSString *);

@interface RegisterViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *userNameFiled;

@property (weak, nonatomic) IBOutlet UITextField *smsCodeFiled;

@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;

@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *rePasswordFiled;

@property (nonatomic,copy) RegisterBackBlock registerBackBlock;
@end
