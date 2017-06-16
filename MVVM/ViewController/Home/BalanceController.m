//
//  BalanceController.m
//  MVVM
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BalanceController.h"
#import "BodyFatCell.h"

@interface BalanceController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *dic;


@property (nonatomic,strong) UITableView *cutableView;

@property (nonatomic,strong) NSMutableArray *nameArray;

@property (nonatomic,strong) NSMutableArray *unitArray;

@property (nonatomic,strong) NSMutableArray *dataSouce;


@end

@implementation BalanceController {
    NSString *identify;
    NSString *currentWater;
    NSString *currentWeight;
    UILabel *titleLabel;
    UILabel *bigWightLabel;
    NSString *curretnValue;
    UILabel *waterResult;
    UILabel *bodyFatResult;
    UILabel *bigGradeLabel;
    UILabel *changeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self initName];
    [self initUnit];
    
    //创建表视图
    identify = @"BodyFatCell";
    
    [self createTableView];
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

- (void)createTableView {
    self.cutableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.cutableView.dataSource = self;
    self.cutableView.delegate = self;
    //设置头视图
    self.cutableView.tableHeaderView = [self createTableHeadView];
    self.cutableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:self.cutableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BodyFatCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[BodyFatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.nameLabel.text = self.nameArray[indexPath.row];
    cell.unitLabel.text = self.unitArray[indexPath.row];
    
    if (self.dataSouce.count > 0) {
        cell.resultLabel.text = self.dataSouce[indexPath.row];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (UIView *)createTableHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    //蓝牙未连接
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"(YunChen)未连接";
    [headView addSubview:titleLabel];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"测量" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:testButton];
    
    //大的圈圈
    UIImageView *resultImgeView = [[UIImageView alloc] init];
    resultImgeView.image = [UIImage imageNamed:@"tzbeijing"];
    [headView addSubview:resultImgeView];
    
    //大圈圈的分数
    bigGradeLabel = [[UILabel alloc] init];
    bigGradeLabel.text = @"0.0分";
    bigGradeLabel.textColor = [UIColor orangeColor];
    bigGradeLabel.font = [UIFont systemFontOfSize:13];
    bigGradeLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:bigGradeLabel];
    
    //分割线
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:sepLine];
    
    //大圈圈的结果
    bigWightLabel = [[UILabel alloc] init];
    currentWeight = @"0";
    bigWightLabel.text = [NSString stringWithFormat:@"%@kg",currentWeight];
    bigWightLabel.font = [UIFont systemFontOfSize:13];
    bigWightLabel.textColor = [UIColor orangeColor];
    bigWightLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:bigWightLabel];
    
    //切换账号
//    UserModel *userModel = [kUserConfig getAllInformation];
    changeLabel = [[UILabel alloc] init];
    changeLabel.text = @"测试";
    [headView addSubview:changeLabel];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:changeButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).with.offset(15);
        make.top.equalTo(headView).with.offset(10);
        
    }];
    
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(titleLabel);
        make.left.equalTo(titleLabel);
        make.right.equalTo(titleLabel);
    }];
    
    
    [resultImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView);
    }];
    
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).with.offset(-15);
        make.top.equalTo(headView).with.offset(10);
        
    }];
    
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(changeLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(changeLabel);
        make.left.equalTo(changeLabel);
        make.right.equalTo(changeLabel);
        
    }];
    
    UILabel *waterLabel = [[UILabel alloc] init];
    waterLabel.text = @"体水分";
    [headView addSubview:waterLabel];
    
    UIImageView *waterImageView = [[UIImageView alloc] init];
    waterImageView.image = [UIImage imageNamed:@"tishuibeijing"];
    [headView addSubview:waterImageView];
    
    waterResult = [[UILabel alloc] init];
    waterResult.text = @"%0.0";
    waterResult.font = [UIFont systemFontOfSize:13];
    [headView addSubview:waterResult];
    
    [waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(headView).with.offset(-5);
        make.left.equalTo(headView).with.offset(10);
        
    }];
    
    [waterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(waterLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(waterLabel);
        
    }];
    
    [waterResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(waterImageView);
        make.centerY.equalTo(waterImageView);
    }];
    
    
    UILabel *bodyFatLabel = [[UILabel alloc] init];
    bodyFatLabel.text = @"体脂率";
    [headView addSubview:bodyFatLabel];
    
    
    UIImageView *bodyFatImgeView = [[UIImageView alloc] init];
    bodyFatImgeView.image = [UIImage imageNamed:@"tishuibeijing"];
    [headView addSubview:bodyFatImgeView];
    
    bodyFatResult = [[UILabel alloc] init];
    bodyFatResult.text = @"%0.0";
    bodyFatResult.font = [UIFont systemFontOfSize:13];
    [headView addSubview:bodyFatResult];
    
    [bodyFatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).with.offset(-5);
        make.right.equalTo(headView).with.offset(-10);
    }];
    
    [bodyFatImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bodyFatLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(bodyFatLabel);
    }];
    
    [bodyFatResult mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(bodyFatImgeView);
        make.centerY.equalTo(bodyFatImgeView);
    }];
    
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(resultImgeView).with.offset(10);
        make.centerY.equalTo(resultImgeView);
        make.centerX.equalTo(resultImgeView);
        make.right.equalTo(resultImgeView).with.offset(-10);
        make.height.mas_equalTo(2);
    }];
    
    [bigGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sepLine);
        make.bottom.equalTo(sepLine.mas_top).with.offset(-10);
    }];
    
    
    [bigWightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sepLine);
        make.top.equalTo(sepLine.mas_bottom).with.offset(10);
    }];
    return headView;
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

- (NSMutableArray *)dataSouce{
    if (_dataSouce == nil) {
        _dataSouce = [[NSMutableArray alloc] init];
    }
    return _dataSouce;
}

#pragma mark - 测量响应方法
- (void)testAction:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"设备连接中..."];
    titleLabel.text = [NSString stringWithFormat:@"(YunChen)连接中..."];
    ;
//    ScanBodyBalance *bady = [ScanBodyBalance sharedInstance];
//    [bady connect];
}

#pragma mark - 切换账号
- (void)changAction:(UIButton *)sender {
//    ChangUserController *changVC = [[ChangUserController alloc] init];
//    [self.navigationController pushViewController:changVC animated:YES];
}

/*
- (NSString *)getBmi:(float)tz {
//    UserModel *userModel = [kUserConfig getAllInformation];
//    TestUserModel *testModel = userModel.testUserModel;
//    CGFloat sgs = [testModel.height floatValue] / 100;
//    NSInteger bmi = tz / (sgs * sgs);
//    return [NSString stringWithFormat:@"%ld",bmi];
}

- (NSString *)yaotunbi {
//    UserModel *userModel = [kUserConfig getAllInformation];
//    TestUserModel *testModel = userModel.testUserModel;
//    NSInteger bi = [testModel.waist floatValue] / [testModel.hip floatValue];
//    return [NSString stringWithFormat:@"%ld",bi];
}
 */
@end
