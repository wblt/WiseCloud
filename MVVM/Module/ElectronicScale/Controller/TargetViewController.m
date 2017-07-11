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
#import "TargetHeadView.h"
@interface TargetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
    NSMutableArray *isOpenArr;
    
}

@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong) NSMutableDictionary *standardDic;

@property(nonatomic,strong) NSMutableDictionary *unitDic;

@property (nonatomic,strong) NSMutableDictionary *contentDic;

@property (nonatomic,strong) TargetHeadView *headView;

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指标标准";
    
    // 初始化item
    [self initNameArray];
    
    // 初始化操作
    [self initOpenArr];
    
    [self initData];
    
    [self initUnitDic];
    
    [self initStandardDic];
    
    [self initContentDic];
    
    // 初始化表视图
    [self initTableView];
}

- (void)initOpenArr {
    isOpenArr = [NSMutableArray array];
    for (int i =0; i< self.dataArr.count; i++) {
        [isOpenArr addObject:@"0"];
    }
}

- (NSMutableDictionary *)unitDic {
    if (_unitDic == nil) {
        _unitDic = [[NSMutableDictionary alloc] init];
    }
    return _unitDic;
}

- (NSMutableDictionary *)contentDic {
    if(_contentDic == nil) {
        _contentDic = [[NSMutableDictionary alloc] init];
    }
    return _contentDic;
}


- (NSMutableDictionary *)standardDic {
    if(_standardDic == nil) {
        _standardDic = [[NSMutableDictionary alloc] init];
    }
    return _standardDic;
}

// 初始化内容
- (void)initContentDic {
    [self.contentDic setObject:@"体重：衡量健康一个重要指标，保持合理健康的生活方式，适量参加运动，您就可以维持标准体重了。" forKey:@"体重"];
    [self.contentDic setObject:@"体水分：适量饮水，适当运动，均衡饮食，保持身体水分的平衡。" forKey:@"体水分"];
    [self.contentDic setObject:@"体脂率：保持好的饮食习惯是保持身体健康身材的最佳途径。" forKey:@"体脂率"];
    [self.contentDic setObject:@"去脂体重：是指除脂肪以外其他成分的重量，肌肉是其中的主要成分，通过该指标可以看出你的锻炼效果，也可以看出您减肥的潜力哦。" forKey:@"去脂体重"];
    [self.contentDic setObject:@"BMI:是指身体质量指数，国际上常用的衡量人体肥胖程度以及是否健康的一个标准。" forKey:@"BMI"];
    [self.contentDic setObject:@"基础代谢量：持续轻量的运动能提高身体的基础代谢量，而节食基础代谢会大幅下降。" forKey:@"基础代谢量"];
    [self.contentDic setObject:@"皮下脂肪率：适当的运动量和合理的饮食能保持适量的皮下脂肪。" forKey:@"皮下脂肪率"];
    [self.contentDic setObject:@"内脏脂肪：检测人体内脏健康的一个指标。" forKey:@"内脏脂肪等级"];
    [self.contentDic setObject:@"骨骼肌率：人体有多个肌肉组成，其中骨骼肌是可以通过锻炼增加的肌肉。" forKey:@"骨骼肌率"];
    [self.contentDic setObject:@"骨量：通过进行健康饮食和适当的锻炼达到标准。" forKey:@"骨量"];
    [self.contentDic setObject:@"蛋白质：生命的物质基础，是构成细胞的基本有机物。" forKey:@"蛋白质"];
    [self.contentDic setObject:@"体年龄：理想的体年龄=实际年龄*2/3" forKey:@"体年龄"];
    [self.contentDic setObject:@"肌肉量：全身的肌肉重量，包括骨骼肌，心肌，平滑肌" forKey:@"肌肉量"];
    [self.contentDic setObject:@"腰臀比：如果保持在0.8-0.9左右将令你拥有令人羡慕的身材。" forKey:@"腰臀比"];
}

- (void)initNameArray {
    [self.dataArr addObject:@"体重"];
    [self.dataArr addObject:@"体水分"];
    [self.dataArr addObject:@"体脂率"];
    [self.dataArr addObject:@"去脂体重"];
    [self.dataArr addObject:@"BMI"];
    [self.dataArr addObject:@"基础代谢量"];
    [self.dataArr addObject:@"皮下脂肪量"];
    [self.dataArr addObject:@"内脏脂肪等级"];
    [self.dataArr addObject:@"骨骼肌率"];
    [self.dataArr addObject:@"骨量"];
    [self.dataArr addObject:@"蛋白质"];
    [self.dataArr addObject:@"体年龄"];
    [self.dataArr addObject:@"肌肉量"];
    [self.dataArr addObject:@"腰臀比"];
    
}

// 初始化标准
- (void)initStandardDic {
    [self.standardDic setValue:@"标准" forKey:@"体重"];
    [self.standardDic setValue:@"标准" forKey:@"体水分"];
    [self.standardDic setValue:@"标准" forKey:@"体脂率"];
    [self.standardDic setValue:@"标准" forKey:@"去脂体重"];
    [self.standardDic setValue:@"标准" forKey:@"BMI"];
    [self.standardDic setValue:@"标准" forKey:@"基础代谢量"];
    [self.standardDic setValue:@"标准" forKey:@"皮下脂肪量"];
    [self.standardDic setValue:@"标准" forKey:@"内脏脂肪等级"];
    [self.standardDic setValue:@"标准" forKey:@"骨骼肌率"];
    [self.standardDic setValue:@"标准" forKey:@"骨量"];
    [self.standardDic setValue:@"标准" forKey:@"蛋白质"];
    [self.standardDic setValue:@"标准" forKey:@"体年龄"];
    [self.standardDic setValue:@"标准" forKey:@"肌肉量"];
    [self.standardDic setValue:@"标准" forKey:@"腰臀比"];
}

// 初始化单位
- (void)initUnitDic {
    [self.unitDic setValue:@"kg" forKey:@"体重"];
    [self.unitDic setValue:@"%" forKey:@"体水分"];
    [self.unitDic setValue:@"%" forKey:@"体脂率"];
    [self.unitDic setValue:@"kg" forKey:@"去脂体重"];
    [self.unitDic setValue:@"" forKey:@"BMI"];
    [self.unitDic setValue:@"kcal" forKey:@"基础代谢量"];
    [self.unitDic setValue:@"%" forKey:@"皮下脂肪量"];
    [self.unitDic setValue:@"级" forKey:@"内脏脂肪等级"];
    [self.unitDic setValue:@"%" forKey:@"骨骼肌率"];
    [self.unitDic setValue:@"kg" forKey:@"骨量"];
    [self.unitDic setValue:@"kcal" forKey:@"蛋白质"];
    [self.unitDic setValue:@"岁" forKey:@"体年龄"];
    [self.unitDic setValue:@"kg" forKey:@"肌肉量"];
    [self.unitDic setValue:@"" forKey:@"腰臀比"];
}

// 初始化表视图
- (void)initTableView {
    // 初始化数据
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate =self;
    _tableview.dataSource = self;
    _tableview.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    [self.view addSubview:_tableview];
    UIView* headView = [[NSBundle mainBundle] loadNibNamed:@"TargetHeadView" owner:nil options:nil].lastObject;
    self.headView = (TargetHeadView *)headView;
    self.headView.headFengshu.text = [NSString stringWithFormat:@"%@分",self.dicData[@"分数"]];
    headView.frame = CGRectMake(0, -180, kScreenWidth, 180);
    [_tableview addSubview:headView];
    [_tableview registerNib:[UINib nibWithNibName:@"TargetCell" bundle:nil] forCellReuseIdentifier:@"TargetCell"];
}

// 初始化数据
- (void)initData {
    // 去脂体重
    NSString *weight = [self.dicData objectForKey:@"体重"];
    [self.dicData setValue:weight forKey:@"去脂体重"];
    // 蛋白质
    [self.dicData setValue:@"" forKey:@"蛋白质"];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
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
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"wb_%ld",indexPath.section+1]];
    
    NSString *name = self.dataArr[indexPath.section];
    //cell.cyan.frame
    cell.lable.text = self.contentDic[name];
    if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 11) {
        cell.img.hidden = YES;
        cell.cyan.hidden = YES;
        cell.heightConstraint.constant = 0;
    }else {
        cell.img.hidden = NO;
        cell.cyan.hidden = NO;
        cell.heightConstraint.constant = 60;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.dataArr[indexPath.section];
    NSString *content = self.contentDic[name];
    CGFloat height = [Tools heightForString:content andWidth:(kScreenWidth - 40)];
    if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 11) {
        return height;
    }else {
        return height + 70;
    }
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
    NSString *name = self.dataArr[section];
    view.lable1.text = name;
    if (nil != self.dicData) {
        NSString *result = [self.dicData objectForKey:self.dataArr[section]];
        if (nil == result || result.length == 0) {
            view.lable2.text = @"--";
        } else {
            NSString *result = [self.dicData objectForKey:name];
            NSString *unit = [self.unitDic objectForKey:name];
            NSString *lable2Str = [NSString stringWithFormat:@"%@%@",result,unit];
            view.lable2.text = lable2Str;
        }
    } else {
       view.lable2.text = @"--";
    }
    // 这里应该加一个方法来计算标准值
    view.lable3.text = self.standardDic[name];
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
    
    // 判断是否是最后一个
    if ([isOpenArr[index] isEqualToString:@"1"]) {
        if (index == (self.dataArr.count - 1)) {
            [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    
    }
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
