//
//  BalanceController.m
//  MVVM
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BalanceController.h"

@interface BalanceController ()

@property (nonatomic,strong) NSMutableDictionary *dic;


@property (nonatomic,strong) UITableView *cutableView;


@end

@implementation BalanceController {
    NSString *identify;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)dic{
    if (_dic == nil) {
        _dic = [[NSMutableDictionary alloc] init];
    }
    return _dic;
}




@end
