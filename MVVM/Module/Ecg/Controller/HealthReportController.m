//
//  HealthReportController.m
//  HuiJianKang
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "HealthReportController.h"

#import "HealthReportCell.h"

#import "HealthReportModel.h"

@interface HealthReportController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HealthReportController {
    NSString *identify;
    NSMutableDictionary *dataDic;
    
    UITableView *cutableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"健康报告";
    identify = @"HealthReportCell";
    NSMutableArray *tmpArry = [NSMutableArray array];
    dataDic = [NSMutableDictionary dictionary];
    NSString *pkuang = [NSString stringWithFormat:@"   宽度______秒，正常值<0.11秒,异常就表示有心房过大危险，伴随症状是呼吸困难，下肢水肿等。"];
    NSString *pzhengfu = [NSString stringWithFormat:@"   振幅______毫秒,正常值<0.25毫秒,异常就表示有心房过大危险，伴随症状是呼吸困难，下肢水肿等。"];
    NSString *pfangxiang = [NSString stringWithFormat:@"  方向______。正常直立的P波，其波顶一般是圆凸的。异常表示激动自房室交界区向心房逆行传导，常见于房室交界性心律，这是一种异位心律,常伴随有心慌气短。"];
    [tmpArry addObject:pkuang];
    [tmpArry addObject:pzhengfu];
    [tmpArry addObject:pfangxiang];
    [dataDic setObject:tmpArry forKey:@"p波"];
    
    NSString *prStr = [NSString stringWithFormat:@"  ______秒，成人应为0.12~0.20秒，在心率加快时P-R可相应的略为缩短，年龄越大或心率越慢，其PR间期越长。异常说明有房室传导障碍，常见于房室传导阻滞等。"];
    [dataDic setObject:prStr forKey:@"pr期间"];
    NSString *qrsStr = [NSString stringWithFormat:@"  宽度______秒，正常成人为0.06~0.10秒，儿童0.04~0.08秒。QRS波群时间或室壁激动时间延长常见于心室肥大或心室内传导阻滞等。"];
    [dataDic setObject:qrsStr forKey:@"qrs波群"];
    NSString *qStr = [NSString stringWithFormat:@"  宽度______<0.4秒，除了aVR导联可呈QS或Qr型外，Q波的振幅不得超过同导联R波的1/4，无切迹。超过正常范围的Q波称为异常Q波，常见于心肌梗塞等。"];
    [dataDic setObject:qStr forKey:@"q波"];
    NSString *styaodiStr = [NSString stringWithFormat:@"  压低______毫伏，任一导联向下偏移都不应超过0.05毫伏,超过正常范围的Q波称为异常Q波，常见于心肌梗塞等。"];
    NSString *styaogaoStr = [NSString stringWithFormat:@"  压高______毫伏，肢体导联级V4-V6导联向上偏移不应超过0.1毫伏,S-T 上移超过正常范围多见于急性心肌梗塞、急性心包炎等。"];
    tmpArry = [NSMutableArray array];
    [tmpArry addObject:styaodiStr];
    [tmpArry addObject:styaogaoStr];
    [dataDic setObject:tmpArry forKey:@"st段"];
    
    NSString *tStr = [NSString stringWithFormat:@"  T波形态：______T波高度______。以R波为主导联中均应直立，T波的振幅不应低于同导联R波的1/10。T波低平或倒置，常见于心肌缺血、低血钾等。"];
    [dataDic setObject:tStr forKey:@"t波"];
    
    NSString *qtStr = [NSString stringWithFormat:@"  ______秒，QTc（QT/√RR）______秒。正常范围0.36-0.44秒。Q-T间期延长见于心动过缓、心肌损害、心脏肥大、心力衰竭、低血钙、低血钾、冠心病、Q-T间期延长综合征、药物作用等。Q-T间期缩短见于高血钙、洋地黄作用、应用肾上腺素等。"];
    [dataDic setObject:qtStr forKey:@"qt期间"];
    
    [self creatTableView];
    
    //加载数据
    [self loadData];
}

- (void)loadData {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlstr = [NSString stringWithFormat:@"getecgreport.htm?deviceid=%@",userModel.defaultDeVice];
    [NetRequestClass afn_requestURL:urlstr httpMethod:kGET params:nil successBlock:^(id returnValue) {
        if (![returnValue isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSDictionary *dic = (NSDictionary *)returnValue;
        //        NSDictionary *dic =  @{
        //            @"ecg.report.qrscomplex.morphology": @"",
        //            @"ecg.report.rhythm": @"0002",
        //            @"ecg.report.pwave.amplitude": @"0.08605",
        //            @"ecg.report.pwave.morphology": @"",
        //            @"ecg.report.stsegment.elevation": @"0",
        //            @"ecg.report.qwave.width": @"0.01168",
        //            @"ecg.report.torwave.height":@"0.11115",
        //            @"ecg.report.pr.interval": @"0.12821",
        //            @"ecg.report.qt.interval": @"0.42",
        //            @"ecg.report.stsegment.depression": @"0",
        //            @"ecg.report.twave.morphology": @"双向",
        //            @"ecg.report.qtc": @"0.4",
        //            @"ecg.report.pwave.direction": @"正常直立的",
        //            @"ecg.report.qrscomplex.width": @"0.10053",
        //            @"ecg.report.heart.rhythm": @"78",
        //            @"ecg.report.pwave.width": @"0.09",
        //            @"ecg.report.summary": @""
        //            };
        HealthReportModel *model = [[HealthReportModel alloc] init];
        model.pwidth = dic[@"ecg.report.pwave.width"];
        model.pzhengfu = dic[@"ecg.report.pwave.amplitude"];
        model.pfangxiang = dic[@"ecg.report.pwave.direction"];
        model.pr = dic[@"ecg.report.pr.interval"];
        model.qrswidth = dic[@"ecg.report.qrscomplex.width"];
        model.qwith = dic[@"ecg.report.qwave.width"];
        model.stdi = dic[@"ecg.report.stsegment.elevation"];
        model.stgao = dic[@"ecg.report.stsegment.depression"];
        model.qtqijina = dic[@"ecg.report.qt.interval"];
        model.qtc = dic[@"ecg.report.qtc"];
        
        [self updataDataDic:model];
        
        [cutableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)creatTableView {
    cutableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    cutableView.dataSource = self;
    cutableView.delegate = self;
    [self.view addSubview:cutableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (section == 4) {
        return 1;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthReportCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HealthReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.section == 0) {
        NSArray *temp = dataDic[@"p波"];
        [cell setDataWithDic:temp[indexPath.row]];
    }
    else if (indexPath.section == 1) {
        NSString *content = dataDic[@"pr期间"];
        [cell setDataWithDic:content];
    }
    else if (indexPath.section == 2) {
        NSString *content = dataDic[@"qrs波群"];
        [cell setDataWithDic:content];
    }
    else if (indexPath.section == 3) {
        NSString *content = dataDic[@"q波"];
        [cell setDataWithDic:content];
    }
    else if (indexPath.section == 4) {
        NSArray *temparr = dataDic[@"st段"];
        [cell setDataWithDic:temparr[indexPath.row]];
    }
    else if (indexPath.section == 5) {
        NSString *content = dataDic[@"t波"];
        [cell setDataWithDic:content];
    }
    else if (indexPath.section == 6) {
        NSString *content = dataDic[@"qt期间"];
        [cell setDataWithDic:content];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"P波:";
    }
    else if (section == 1) {
        return @"PR期间:";
    }
    else if (section == 2) {
        return @"QRS波群:";
    }
    else if (section == 3) {
        return @"Q波:";
    }
    else if (section == 4) {
        return @"S-T段:";
    }
    else if (section == 5) {
        return @"T波:";
    }
    else {
        return @"QT期间:";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 105;
        }
        else {
            return 80;
            
        }
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else if (indexPath.section == 2) {
        return 100;
    }
    else if (indexPath.section == 3) {
        return 105;
    }
    else if (indexPath.section == 5) {
        return 105;
    }
    else if (indexPath.section == 6) {
        return 150;
    }
    else {
        return 95;
    }
}

- (void)updataDataDic:(HealthReportModel *)model {
    NSMutableArray *tmpArry = [NSMutableArray array];
    dataDic = [NSMutableDictionary dictionary];
    NSString *pkuang = [NSString stringWithFormat:@"   宽度___%@___秒，正常值<0.11秒,异常就表示有心房过大危险，伴随症状是呼吸困难，下肢水肿等。",model.pwidth];
    NSString *pzhengfu = [NSString stringWithFormat:@"   振幅___%@___毫秒,正常值<0.25毫秒,异常就表示有心房过大危险，伴随症状是呼吸困难，下肢水肿等。",model.pzhengfu];
    NSString *pfangxiang = [NSString stringWithFormat:@"  方向___%@___。正常直立的P波，其波顶一般是圆凸的。异常表示激动自房室交界区向心房逆行传导，常见于房室交界性心律，这是一种异位心律,常伴随有心慌气短。",model.pfangxiang];
    [tmpArry addObject:pkuang];
    [tmpArry addObject:pzhengfu];
    [tmpArry addObject:pfangxiang];
    [dataDic setObject:tmpArry forKey:@"p波"];
    
    NSString *prStr = [NSString stringWithFormat:@"  ___%@___秒，成人应为0.12~0.20秒，在心率加快时P-R可相应的略为缩短，年龄越大或心率越慢，其PR间期越长。异常说明有房室传导障碍，常见于房室传导阻滞等。",model.pr];
    [dataDic setObject:prStr forKey:@"pr期间"];
    NSString *qrsStr = [NSString stringWithFormat:@"  宽度___%@___秒，正常成人为0.06~0.10秒，儿童0.04~0.08秒。QRS波群时间或室壁激动时间延长常见于心室肥大或心室内传导阻滞等。",model.qrswidth];
    [dataDic setObject:qrsStr forKey:@"qrs波群"];
    NSString *qStr = [NSString stringWithFormat:@"  宽度___%@___<0.4秒，除了aVR导联可呈QS或Qr型外，Q波的振幅不得超过同导联R波的1/4，无切迹。超过正常范围的Q波称为异常Q波，常见于心肌梗塞等。",model.qwith];
    [dataDic setObject:qStr forKey:@"q波"];
    NSString *styaodiStr = [NSString stringWithFormat:@"  压低___%@___毫伏，任一导联向下偏移都不应超过0.05毫伏,超过正常范围的Q波称为异常Q波，常见于心肌梗塞等。",model.stdi];
    NSString *styaogaoStr = [NSString stringWithFormat:@"  压高___%@___毫伏，肢体导联级V4-V6导联向上偏移不应超过0.1毫伏,S-T 上移超过正常范围多见于急性心肌梗塞、急性心包炎等。",model.stgao];
    tmpArry = [NSMutableArray array];
    [tmpArry addObject:styaodiStr];
    [tmpArry addObject:styaogaoStr];
    [dataDic setObject:tmpArry forKey:@"st段"];
    
    NSString *tStr = [NSString stringWithFormat:@"  T波形态：___%@___T波高度___%@___。以R波为主导联中均应直立，T波的振幅不应低于同导联R波的1/10。T波低平或倒置，常见于心肌缺血、低血钾等。",model.tbxingtai,model.tbgaodu];
    [dataDic setObject:tStr forKey:@"t波"];
    
    NSString *qtStr = [NSString stringWithFormat:@"  ___%@___秒，QTc（QT/√RR）___%@___秒。正常范围0.36-0.44秒。Q-T间期延长见于心动过缓、心肌损害、心脏肥大、心力衰竭、低血钙、低血钾、冠心病、Q-T间期延长综合征、药物作用等。Q-T间期缩短见于高血钙、洋地黄作用、应用肾上腺素等。",model.qtqijina,model.qtc];
    [dataDic setObject:qtStr forKey:@"qt期间"];
}
@end
