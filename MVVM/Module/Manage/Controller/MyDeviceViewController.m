//
//  MyDeviceViewController.m
//  HuiJianKang
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "MyDeviceCell.h"
#import "MyDeviceModel.h"
#import "AddDeviceViewController.h"

@interface MyDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,SDMyDeviceCellDelegate>
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, strong) NSMutableArray *deviceArr;
@end

@implementation MyDeviceViewController {
    UITableView *cuTableView;
    
    NSMutableArray *dataSouce;
    
    NSString *identify;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self createTableView];
    
    [self createLeftNavButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //这里来添加一个请求设备的列表
    [self getDeviceList];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)getDeviceList {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"hjkSeeBinding.htm?phone=%@",userModel.userPhoneNum];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil  successBlock:^(id data) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",data);
        NSArray *dataArray = (NSArray *)data;
        if (dataArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您未绑定设备,请点右上角添加设备" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertView show];
            
            return ;
        }
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < dataArray.count; i++) {
            MyDeviceModel *model = [MyDeviceModel mj_objectWithKeyValues:dataArray[i]];
            [temp addObject:model];
        }
        _deviceArr = [temp copy];
        userModel.deviceArray = [temp copy];
        if (userModel.defaultDeVice.length == 0) {
            MyDeviceModel *tempModel = [userModel.deviceArray firstObject];
            userModel.defaultDeVice = tempModel.deviceid;
        }
        //保存
        [[UserConfig shareInstace] setAllInformation:userModel];
        [cuTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
}

- (void)createLeftNavButton {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [_rightBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)rightBtnClick:(UIButton *)sender {
    
    AddDeviceViewController *add = [[AddDeviceViewController alloc] initWithNibName:@"AddDeviceViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}


#pragma mark - 创建表视图
- (void)createTableView {
    identify  = @"MyDeviceCell";
    cuTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    cuTableView.dataSource = self;
    cuTableView.delegate = self;
    [self.view addSubview:cuTableView];
}

#pragma mark - 创建表视图
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    dataSouce = [NSMutableArray array];
    [dataSouce addObjectsFromArray:_deviceArr];
    return dataSouce.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.delegate = self;
    
    cell.model = _deviceArr[indexPath.row];

    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 20)];

    titleLabel.text = @"手表设备";
    
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //此处加一个弹出的方法
    
    [self showAlterVC:indexPath];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)showAlterVC:(NSIndexPath *)indexPath {
    MyDeviceModel *model = _deviceArr[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"是否设置%@为默认设备",model.weixinnickname];
    
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
        userModel.defaultDeVice = model.deviceid;
        [[UserConfig shareInstace] setAllInformation:userModel];
        [cuTableView reloadData];
    }];
    

    UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alterVC addAction:canceAction];
    
    [alterVC addAction:qureAction];
    
    [self presentViewController:alterVC animated:YES completion:nil];
    
}


- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    _currentEditingIndexthPath = [cuTableView indexPathForCell:cell];

    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:@"是否解除绑定设备？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletCurrentDevice];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alerVC addAction:action1];
    [alerVC addAction:action2];
    
    [self presentViewController:alerVC animated:YES completion:nil];
}

- (void)deletCurrentDevice {
    MyDeviceModel *tempModel = dataSouce[_currentEditingIndexthPath.row];
    /*http://101.201.80.234:8080/watchclient/delMemberbinding.htm?phone=13620208169&deviceid=626010110252486*/
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"delMemberbinding.htm?phone=%@&deviceid=%@",userModel.userPhoneNum,userModel.defaultDeVice];
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil  successBlock:^(id data) {
        NSInteger num = [data integerValue];
        if (num == 0) {
            [SVProgressHUD showSuccessWithStatus:@"解绑成功"];
            [dataSouce removeObject:tempModel];
            [cuTableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"解绑失败"];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
