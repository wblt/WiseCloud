//
//  RecordViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RecordViewController.h"
#import "DateCell.h"
#import "RecordModel.h"
@interface RecordViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentIndex;
    NSArray *arr1;
    NSArray *arr2;
    NSString *date;
}
@property (weak, nonatomic) IBOutlet UITableView *dateTable;
@property (weak, nonatomic) IBOutlet UITableView *deteilTable;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _dateTable.dataSource = self;
    _dateTable.delegate = self;
    _dateTable.rowHeight = 60;
    _dateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deteilTable.dataSource = self;
    _deteilTable.delegate = self;
    _deteilTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dateTable registerNib:[UINib nibWithNibName:@"DateCell" bundle:nil] forCellReuseIdentifier:@"datecell"];
    
    arr1 = @[@"体重",@"体水分",@"体脂率",@"去脂体重",@"BMI",@"基础代谢量",@"皮下脂肪率",@"内脏脂肪等级",@"骨骼肌率",@"骨量",@"蛋白质",@"体年龄",@"肌肉量"];
    
    [self requestData];
}

- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"selectbodyfat.htm?loginname=%@&identity=39",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNum"]];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [NetRequestClass requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        [SVProgressHUD dismiss];
        NSArray *dataArray = (NSArray *)data;
        for (int i = 0; i < dataArray.count; i++) {
            RecordModel *model = [RecordModel mj_objectWithKeyValues:dataArray[i]];
            [_dataArr addObject:model];
        }
        
        [_dateTable reloadData];
        [_deteilTable reloadData];
        NSIndexPath * path = [NSIndexPath indexPathForItem:0 inSection:0];
        [self tableView:_dateTable didSelectRowAtIndexPath:path];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _dateTable) {
        return _dataArr.count;
    }else if (tableView == _deteilTable) {
        return arr1.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _dateTable) {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datecell" forIndexPath:indexPath];
        cell.budgeBtn.tag = indexPath.row + 300;
        if (cell.budgeBtn.tag == currentIndex+300) {
            cell.width.constant = 30;
            cell.height.constant = 30;
            cell.left.constant = 0;
            cell.right.constant = 0;
            cell.budgeBtn.layer.cornerRadius = 15;
        }else {
            cell.width.constant = 20;
            cell.height.constant = 20;
            cell.left.constant = 0;
            cell.right.constant = 5;
            cell.budgeBtn.layer.cornerRadius = 10;
        }
        cell.budgeBtn.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RecordModel *model;
        if (_dataArr.count > indexPath.row) {
            model = _dataArr[indexPath.row];
        }
        NSArray *timeArr = [model.updatetime componentsSeparatedByString:@" "];
        if (timeArr.count > 0) {
            cell.date.text = timeArr[0];
        }else {
            cell.date.text = @"";
        }
        
        return cell;
    }else if (tableView == _deteilTable) {
        static NSString *CellIdentifier = @"deteilcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = arr1[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"bmi"];
        cell.detailTextLabel.text = arr2[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor greenColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dateTable) {
        currentIndex = indexPath.row;
        RecordModel *model;
        if (_dataArr.count > indexPath.row) {
            model = _dataArr[indexPath.row];
        }
        NSArray *timeArr = [model.updatetime componentsSeparatedByString:@" "];
        if (timeArr.count > 1) {
            date = [timeArr[1] stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else {
            date = @"";
        }
        
        arr2 = @[[NSString stringWithFormat:@"%@kg",model.weight],[NSString stringWithFormat:@"%@%%",model.bodyMoisture],[NSString stringWithFormat:@"%@%%",model.bodyFatRatio],[NSString stringWithFormat:@"%@kg",model.nofatWeight],[NSString stringWithFormat:@"%@",model.BMIIndicator],[NSString stringWithFormat:@"%@kcal",model.basalMetabolism],[NSString stringWithFormat:@"%@%%",model.waistHipRatio],[NSString stringWithFormat:@"%@级",model.visceralFatLevels],[NSString stringWithFormat:@"%@%%",model.muscleRate],[NSString stringWithFormat:@"%@kg",model.boneMass],[NSString stringWithFormat:@"%@％",model.protein],[NSString stringWithFormat:@"%@岁",model.bodyAge],[NSString stringWithFormat:@"%.1f kg",[model.nofatWeight floatValue]-[model.boneMass floatValue]]];
        [_dateTable reloadData];
        [_deteilTable reloadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _deteilTable) {
        return 70;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _deteilTable) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-160, 70)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(view.width-65, 10, 50, 50)];
        [btn setImage:[UIImage imageNamed:@"复制"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cutScreen) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, view.width-80, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = date;
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (void)cutScreen
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* viewImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, self, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"截图已保存至手机相册"];
    [SVProgressHUD dismissWithDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
