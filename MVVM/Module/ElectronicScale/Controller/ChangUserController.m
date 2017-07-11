//
//  ChangUserController.m
//  HuiJianKang
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "ChangUserController.h"

#import "TestUserModel.h"

#import "Masonry.h"

#import "TestUserViewController.h"

@interface ChangUserController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChangUserController {
    NSMutableArray *dataSource;
    NSString *identify;
    UITableView *cuTableView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换用户";
    
    identify = @"UITableViewCell";
    //创建表视图
    [self createTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"selectQNuser.htm?phone=%@",userModel.userPhoneNum];
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil  successBlock:^(id data) {
        NSLog(@"%@",data);
        dataSource = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            TestUserModel *model = [TestUserModel mj_objectWithKeyValues:dic];
            [dataSource addObject:model];
        }
        
        if (dataSource.count && userModel.testUserModel == nil) {
            TestUserModel *model = [dataSource firstObject];
            userModel.testUserModel = model;
            [[UserConfig shareInstace] setAllInformation:userModel];
        }
        
        [cuTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)createTableView {
    cuTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    cuTableView.dataSource = self;
    cuTableView.delegate = self;
    [self.view addSubview:cuTableView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加用户" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:230/255.0 blue:250/255.0 alpha:1];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
        make.height.mas_equalTo(50);
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    TestUserModel *model = dataSource[indexPath.row];
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    if ([userModel.testUserModel.careID isEqualToString:model.careID]) {
        cell.textLabel.text = [NSString stringWithFormat:@"(当前用户)%@",model.name];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showAlertVC:indexPath];
    
}

- (void)addButtonAction:(UIButton *)button {
    TestUserViewController *testVC = [[TestUserViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)showAlertVC:(NSIndexPath *)indexPath {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"修改或者切换用户" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        TestUserViewController *testVC = [[TestUserViewController alloc] init];
        [self.navigationController pushViewController:testVC animated:YES];
    }];
    
    UIAlertAction *qureAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TestUserModel *model = dataSource[indexPath.row];
        UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
        userModel.testUserModel = model;
        [[UserConfig shareInstace] setAllInformation:userModel];
        [cuTableView reloadData];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:qureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
