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
    
    self.nameArray = @[@"去脂体重",@"BMI",@"基础代谢量",@"皮下脂肪量",@"内脏脂肪等级",@"肌肉量",@"骨骼肌率",@"骨量",@"体年龄",@"腰臀比"];
    
    self.unitArray = @[@"kg",@"",@"kcal",@"%",@"级",@"kg",@"%",@"kg",@"岁",@""];
    
    
}

- (void)initName {
    [self.nameArray addObject:@"去脂体重"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"基础代谢量"];
    [self.nameArray addObject:@"皮下脂肪量"];
    [self.nameArray addObject:@"内脏脂肪等级"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"BMI"];
    [self.nameArray addObject:@"BMI"];
    
}

- (void)initUnit {
    [self.unitArray addObject:@"kg"];
}

- (void)initUnit {
    
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
