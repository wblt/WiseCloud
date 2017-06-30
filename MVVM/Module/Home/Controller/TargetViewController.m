//
//  TargetViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TargetViewController.h"
#import "TargetCell.h"
#import "TargetSectionView.h"
@interface TargetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
    NSArray        *dataArr;
    NSMutableArray *isOpenArr;
    
}

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指标标准";
    // 初始化数据
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate =self;
    _tableview.dataSource = self;
    _tableview.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    [self.view addSubview:_tableview];
    UIView* pende = [[NSBundle mainBundle] loadNibNamed:@"TargetHeadView" owner:nil options:nil].lastObject;
    pende.frame = CGRectMake(0, -180, kScreenWidth, 180);
    [_tableview addSubview:pende];
    
    [_tableview registerNib:[UINib nibWithNibName:@"TargetCell" bundle:nil] forCellReuseIdentifier:@"TargetCell"];
    
    dataArr = @[@"体重",@"体水分",@"体脂率",@"去脂体重",@"BMI",@"基础代谢量",@"皮下脂肪率",@"内脏脂肪等级",@"骨骼肌率",@"骨量",@"蛋白质",@"体年龄",@"肌肉量"];
    isOpenArr = [NSMutableArray array];
    for (int i =0; i< dataArr.count; i++) {
        [isOpenArr addObject:@"0"];
    }
    [self initData];
}

// 初始化数据
- (void)initData {
    // 去脂体重
    NSString *weight = [self.dicData objectForKey:@"体重"];
    [self.dicData setValue:weight forKey:@"去脂体重"];
    // 蛋白质
    [self.dicData setValue:@"" forKey:@"蛋白质"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([isOpenArr[section] isEqualToString:@"1"])
    {
        return 1;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TargetCell" forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"wb_%d",indexPath.section+1]];
    //cell.cyan.frame
    //cell.lable.text
    if (indexPath.section == 4 || indexPath.section == 11) {
        cell.img.hidden = YES;
        cell.cyan.hidden = YES;
    }else {
        cell.img.hidden = NO;
        cell.cyan.hidden = NO;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//cell.lable.text   height
//    if (indexPath.section == 4 || indexPath.section == 11) {
//        return height;
//    }else {
//        return height + 70;
//    }
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TargetSectionView *view  = [[NSBundle mainBundle] loadNibNamed:@"TargetSectionView" owner:nil options:nil].lastObject;
    view.lable1.text = dataArr[section];
    if (nil != self.dicData) {
        NSString *result = [self.dicData objectForKey:dataArr[section]];
        if (nil == result || result.length == 0) {
            view.lable2.text = @"--";
        } else {
            view.lable2.text = [self.dicData objectForKey:dataArr[section]];
        }
        
    } else {
       view.lable2.text = @"--";
    }
    
    // 这里应该加一个方法来判断
    view.lable3.text = @"标准";
    
    if ([isOpenArr[section] isEqualToString:@"1"]) {
        view.btn.selected = YES;
        view.line.hidden = YES;
    }else{
        view.btn.selected = NO;
        view.line.hidden = NO;
    }
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topgesture:)];
    [view addGestureRecognizer:tap];
    
    view.tag = section;
    return view;
    
}

-(void)topgesture:(UITapGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag;
    
    if ([isOpenArr[index] isEqualToString:@"1"]) {
        
        [isOpenArr replaceObjectAtIndex:index withObject:@"0"];
        
    }else{
        [isOpenArr replaceObjectAtIndex:index withObject:@"1"];
       
    }
    [_tableview reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
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
