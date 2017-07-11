//
//  BalanceController.h
//  MVVM
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BleScaningDecviceModel.h"

@interface BalanceController : BaseViewController

// f100:青牛电子秤 f200:倍康 f300 鑫瑞智
@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) BleScaningDecviceModel *bleModel;

@end
