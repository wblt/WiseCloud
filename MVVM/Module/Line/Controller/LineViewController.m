//
//  LineViewController.m
//  HuiJianKang
//
//  Created by liuzhenhao on 16/5/31.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "LineViewController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"
#import "XinLvModel.h"
#define FCColor0xValue(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
@interface LineViewController ()
{
    NSMutableArray *dataArr;
}
@property (nonatomic,weak) SHLineGraphView *mylineGraph; // 第三方曲线图
@property (strong, nonatomic) UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noData;

@end

@implementation LineViewController

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (NSString *)getCurrentTime1 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 20)];
    self.unitLabel.text = [NSString stringWithFormat:@"单位：%@", self.unitStr];
    self.unitLabel.font = [UIFont systemFontOfSize:10];
    [self.scrollView addSubview:self.unitLabel];
   
    self.titleStr = [NSString stringWithFormat:@"%@ 00:00~%@前的%@趋势图",[self getCurrentTime], [self getCurrentTime1],self.navigationItem.title];
    self.titleLabel.text = self.titleStr;
    [self requestData];
}

- (void)requestData
{
    dataArr = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"加载中"];
    [NetRequestClass afn_requestURL:self.urlStr httpMethod:kGET params:nil successBlock:^(id returnValue) {
        //创建用户模型对象
        if ([returnValue isKindOfClass:[NSArray class]]) {
            NSArray *arr = returnValue;//[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in arr) {
                XinLvModel *model = [XinLvModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }
            if (arr.count>0) {
                [self drawLineView];
                self.noData.hidden = YES;
            }else {
                [self drawLineView];
                self.noData.hidden = NO;
            }
        }
        else {
            [self drawLineView];
            self.noData.hidden = NO;
        }

    } failureBlock:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"服务器错误，检测网络"];
    }];
    
}

-(void)drawLineView{
    self.scrollView.contentSize = CGSizeMake(50*24+20, self.scrollView.height);
    NSMutableArray *moneysArray = [NSMutableArray array];
    //NSMutableArray *hh = [NSMutableArray array];
    for (int i = 1; i<=24*60; i++) {
        [moneysArray addObject:@(0)];
    }
    for (XinLvModel *model in dataArr) {
        NSString *number = @"";
        if (model.heartrateMax!=nil) {
            number = model.heartrateMax;
        }else if (model.sporttep != nil) {
            number = model.sporttep;
        }else if (model.sleeptotal != nil) {
            number = model.sleeptotal;
        }else if (model.systolic != nil) {
            number = model.systolic;
        }else if (model.bloodglucose != nil) {
            number = model.bloodglucose;
        }
        if ([number floatValue]>0) {
            [moneysArray replaceObjectAtIndex:[[model.updatetime substringWithRange:NSMakeRange(11, 2)] integerValue]*60+[[model.updatetime substringWithRange:NSMakeRange(14, 2)] integerValue] withObject:@([number floatValue])];
        }
    }
    
    NSMutableArray *moneysArray1 = [NSMutableArray array];
    //NSMutableArray *hh = [NSMutableArray array];
    for (int i = 1; i<=24*60; i++) {
        [moneysArray1 addObject:@(0)];
    }
    for (XinLvModel *model in dataArr) {
        NSString *number = @"";
        if (model.heartrateMin!=nil) {
            number = model.heartrateMin;
        }else if (model.diastolic != nil) {
            number = model.diastolic;
        }else if (model.sleepdeep != nil) {
            number = model.sleepdeep;
        }
        if ([number floatValue]>0) {
            [moneysArray1 replaceObjectAtIndex:[[model.updatetime substringWithRange:NSMakeRange(11, 2)] integerValue]*60+[[model.updatetime substringWithRange:NSMakeRange(14, 2)] integerValue] withObject:@([number floatValue])];
        }
    }
    //找出收益最大值
    double maxMoney = 0;
    for (NSNumber *income in moneysArray) {
        if ([income integerValue]>maxMoney) {
            maxMoney = [income integerValue];
        }
//        [moneysArray addObject:[NSNumber numberWithDouble:[income integerValue]]];
    }
    int ymax = (int)maxMoney+ 1;
    
    //隐藏y轴值 - 40
    if (self.mylineGraph) {
        //lineview 吧之前的曲线图去掉
        [self.mylineGraph removeFromSuperview];
        
    }
    
    SHLineGraphView *_lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 50*24, self.scrollView.height)];
    self.mylineGraph = _lineGraph;
    //x y轴上数据颜色及背景横线条颜色，y轴横线间隔
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : FCColor0xValue(0xb3b3b3),
                                       kXAxisLabelFontKey : [UIFont systemFontOfSize:10],
                                       kYAxisLabelColorKey : FCColor0xValue(0xb4b4b4),
                                       kYAxisLabelFontKey : [UIFont systemFontOfSize:10],
                                       kYAxisLabelSideMarginsKey : @10,
                                       kPlotBackgroundLineColorKye : FCColor0xValue(0xe6e6e6)
                                       };
    _lineGraph.themeAttributes = _themeAttributes;
    
    //y轴最大值
    if (ymax <= 5) {
        _lineGraph.yAxisRange = @(5);
    } else if (ymax > 5 && ymax <= 10){
        _lineGraph.yAxisRange = @(10);
    } else if (ymax > 10 && ymax <= 20){
        _lineGraph.yAxisRange = @(20);
    } else if (ymax > 20 && ymax <= 30){
        _lineGraph.yAxisRange = @(30);
    } else if (ymax > 30 && ymax <= 50){
        _lineGraph.yAxisRange = @(50);
    } else if (ymax > 50 && ymax <= 100) {
        _lineGraph.yAxisRange = @(100);
    } else if (ymax > 100 && ymax <= 200) {
        _lineGraph.yAxisRange = @(200);
    } else if (ymax > 200 && ymax <= 300) {
        _lineGraph.yAxisRange = @(300);
    } else if (ymax > 300 && ymax <= 400) {
        _lineGraph.yAxisRange = @(400);
    } else if (ymax > 400 && ymax <= 500) {
        _lineGraph.yAxisRange = @(500);
    } else if (ymax > 500 && ymax <= 800){
        _lineGraph.yAxisRange = @(800);
    } else if (ymax > 800 && ymax <= 1200){
        _lineGraph.yAxisRange = @(1200);
    } else if (ymax > 1200 && ymax <= 2000){
        _lineGraph.yAxisRange = @(2000);
    } else if (ymax > 2000 && ymax <= 5000){
        _lineGraph.yAxisRange = @(5000);
    } else if (ymax > 5000 && ymax <= 10000){
        _lineGraph.yAxisRange = @(10000);
    } else {
        _lineGraph.yAxisRange = @(30000);
    }
    
    //y轴数据后的单位
    _lineGraph.yAxisSuffix = @"";
    NSMutableArray *hh1 = [NSMutableArray array];
    for (int i = 1; i<=24*60; i++) {
        if (i%60==0) {
            NSString *strX = [NSString stringWithFormat:@"%d:00",i/60];
            NSDictionary *dicX = @{[NSNumber numberWithInt:i]:strX};
            [hh1 addObject:dicX];
        }else {
            [hh1 addObject:@{[NSNumber numberWithInt:i]:@""}];
        }
        
    }
    //x轴值
    _lineGraph.xAxisValues = hh1;
    
    SHPlot *_plot1 = [[SHPlot alloc] init];
    
    NSMutableArray *plottingValues = [[NSMutableArray alloc]init];
    for (int i = 0; i<moneysArray.count; i++) {
        if ([moneysArray[i] integerValue]!=0) {
            [plottingValues addObject:@{[NSNumber numberWithInt:i+1]:moneysArray[i]}];
        }
        
    }
    if (plottingValues.count>0) {
        _plot1.plottingValues = plottingValues;
    }
    
    SHPlot *_plot2 = [[SHPlot alloc] init];
    
    NSMutableArray *plottingValues2 = [[NSMutableArray alloc]init];
    for (int i = 0; i<moneysArray1.count; i++) {
        if ([moneysArray1[i] integerValue]!=0) {
            [plottingValues2 addObject:@{[NSNumber numberWithInt:i+1]:moneysArray1[i]}];
        }
        
    }
    if (plottingValues2.count>0) {
        _plot2.plottingValues = plottingValues2;
    }
    
    //点击点弹出视图值
    NSMutableArray *arrPoint = [NSMutableArray array];
    for (int i = 0; i<moneysArray.count; i++) {
        [arrPoint addObject:[NSString stringWithFormat:@"%.2f",[moneysArray[i] floatValue]]];
    }
    if (arrPoint.count>0) {
        _plot1.plottingPointsLabels = arrPoint;
    }
    
    //点击点弹出视图值
    NSMutableArray *arrPoint1 = [NSMutableArray array];
    for (int i = 0; i<moneysArray1.count; i++) {
        [arrPoint1 addObject:[NSString stringWithFormat:@"%.2f",[moneysArray1[i] floatValue]]];
    }
    if (arrPoint1.count>0) {
        _plot2.plottingPointsLabels = arrPoint1;
    }
    
    //set plot theme attributes
    //判断弹出框是否有值，没有值把线和点设成无色
    if (_plot1.plottingPointsLabels && _plot1.plottingPointsLabels.count > 0 && maxMoney > 0) {
        //线，点，阴影颜色及线的宽度,字体
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor clearColor],
                                               kPlotStrokeWidthKey : @2,//线宽
                                               kPlotStrokeColorKey :FCColor0xValue(0xff4f7b),//线颜色
                                               kPlotPointFillColorKey : FCColor0xValue(0xff4f7b),//点颜色
                                               kPlotPointValueFontKey : [UIFont systemFontOfSize:10]//弹出框字体
                                               };
        _plot1.plotThemeAttributes = _plotThemeAttributes;
        
        self.mylineGraph.userInteractionEnabled = YES;
    }
    else{
        
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor clearColor],
                                               kPlotStrokeWidthKey : @2,//线宽
                                               kPlotStrokeColorKey : [UIColor clearColor],//线颜色
                                               kPlotPointFillColorKey : [UIColor clearColor],//点颜色
                                               kPlotPointValueFontKey : [UIFont systemFontOfSize:10]//弹出框字体
                                               };
        _plot1.plotThemeAttributes = _plotThemeAttributes;
        
        self.mylineGraph.userInteractionEnabled = NO;
    }
    
    //判断弹出框是否有值，没有值把线和点设成无色
    if (_plot2.plottingPointsLabels && _plot2.plottingPointsLabels.count > 0 && maxMoney > 0) {
        //线，点，阴影颜色及线的宽度,字体
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor clearColor],
                                               kPlotStrokeWidthKey : @2,//线宽
                                               kPlotStrokeColorKey :RGB(0, 191, 255),//线颜色
                                               kPlotPointFillColorKey : RGB(0, 191, 255),//点颜色
                                               kPlotPointValueFontKey : [UIFont systemFontOfSize:10]//弹出框字体
                                               };
        
        _plot2.plotThemeAttributes = _plotThemeAttributes;
        self.mylineGraph.userInteractionEnabled = YES;
    }
    else{
        
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor clearColor],
                                               kPlotStrokeWidthKey : @2,//线宽
                                               kPlotStrokeColorKey : [UIColor clearColor],//线颜色
                                               kPlotPointFillColorKey : [UIColor clearColor],//点颜色
                                               kPlotPointValueFontKey : [UIFont systemFontOfSize:10]//弹出框字体
                                               };
        
        _plot2.plotThemeAttributes = _plotThemeAttributes;
        self.mylineGraph.userInteractionEnabled = NO;
    }
    
    [_lineGraph addPlot:_plot1];
    [_lineGraph addPlot:_plot2];
    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    [_lineGraph setupTheView];
    
    
    [self.scrollView addSubview:self.mylineGraph];
    
    //判断数据是否有值，有值隐藏默认label
//    if (_plot1.plottingValues && _plot1.plottingValues.count > 0 && maxMoney > 0) {
//        self.noIncome_lab.hidden = YES;
//    }else{
//        self.noIncome_lab.hidden = NO;
//    }
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
