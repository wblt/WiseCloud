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

@property (nonatomic,strong) NSMutableArray *nameArray;

@property (nonatomic,strong) NSMutableArray *unitArray;


@end

@implementation BalanceController {
    NSString *identify;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initName {
    [self.nameArray addObject:@"去脂体重"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"基础代谢量"];
    [self.nameArray addObject:@"皮下脂肪量"];
    [self.nameArray addObject:@"内脏脂肪等级"];
    [self.nameArray addObject:@"肌肉量"];
    [self.nameArray addObject:@"骨骼肌率"];
    [self.nameArray addObject:@"骨量"];
    [self.nameArray addObject:@"体年龄"];
    [self.nameArray addObject:@"腰臀比"];
}

- (void)initUnit {
    [self.unitArray addObject:@"kg"];
    [self.unitArray addObject:@""];
    [self.unitArray addObject:@"kcal"];
    [self.unitArray addObject:@"%"];
    [self.unitArray addObject:@"级"];
    [self.unitArray addObject:@"kg"];
    [self.unitArray addObject:@"%"];
    [self.unitArray addObject:@"岁"];
    [self.unitArray addObject:@""];
    [self.unitArray addObject:@"kg"];
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

- (NSMutableArray *)nameArray{
    if (_nameArray == nil) {
        _nameArray = [[NSMutableArray alloc] init];
    }
    return _nameArray;
}

- (NSMutableArray *)unitArray{
    if (_unitArray == nil) {
        _unitArray = [[NSMutableArray alloc] init];
    }
    return _unitArray;
}
@end
