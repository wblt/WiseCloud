//
//  LocationViewController.m
//  HuiJianKang
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LocationModel.h"
#import "MyAnimatedAnnotationVC.h"
#import "CFPopView.h"

@interface LocationViewController ()<BMKMapViewDelegate>

@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic, strong) CFPopView *popView;

@end

@implementation LocationViewController {
    BMKMapView *_mapView;
    NSMutableArray *dataSource;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    NSString *title;
    NSString *flag;
    NSInteger titleIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载数据
    [self loadData];
    
    //创建地图
    [self createMapView];
    
    [self createLeftNavButton];
    
    NSArray *dictArr = @[@{@"title":@"定位", @"iconName":@"数字-0.png"},@{@"title":@"轨迹", @"iconName":@"数字-1.png"},@{@"title":@"刷新", @"iconName":@"数字-2.png"}];
    
    self.popView = [CFPopView popViewWithFuncDicts:dictArr];
    
    __weak typeof (self) weakSelf = self;
    
    self.popView.myFuncBlock = ^(NSInteger index){
        if (index == 0) {
            //定位
            flag = @"0";
            [weakSelf getCurrentLoaction];
        }
        else if (index == 1) {
            flag = @"1";
            titleIndex = 0;
            //轨迹
            [weakSelf addPathWay];
            
        }
        else if (index == 2) {
            //刷新
            flag = @"2";
            [weakSelf loadData];
        }
        weakSelf.rightBtn.selected = NO;
        [weakSelf.popView dismissFromKeyWindow];
    };
}

- (void)createMapView {
    //创建地图视图
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 17;
    _mapView.delegate = self;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
}

- (void)loadData {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"seeMembergpsTo10.htm?phone=%@",userModel.defaultDeVice];
    
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil successBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        
        if (![returnValue isKindOfClass:[NSArray class]]) {
            return ;
        }
        NSArray *arrayData = (NSArray *)returnValue;
        if (arrayData.count == 0) {
            [SVProgressHUD showWithStatus:@"设备未联网或者没有定位数据"];
            return ;
        }
        dataSource = [NSMutableArray array];
        for (NSDictionary *dic in arrayData) {
            LocationModel *model = [LocationModel mj_objectWithKeyValues:dic];
            [dataSource addObject:model];
        }
        
        LocationModel *model = [dataSource firstObject];
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        
        [self addAnimatedAnnotation:model];
    } failureBlock:^(NSError *error){
        NSLog(@"%@",error);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

//添加轨迹
- (void)addPathWay {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (dataSource.count == 0) {
        return;
    }
    
    for (int i = 0;i < dataSource.count;i++)
    {
        LocationModel *model = dataSource[i];
        
        [self addAnimatedAnnotation:model];
    }
}

// 添加动画Annotation
- (void)addAnimatedAnnotation:(LocationModel *)model {
    animatedAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [model.latitude doubleValue];
    coor.longitude = [model.longitude doubleValue];
    animatedAnnotation.coordinate = coor;
    _mapView.centerCoordinate = coor;
    title = [NSString stringWithFormat:@"定位时间:%@\n定位坐标:lat:%@ lon:%@\n定位地址:%@",model.updatetime,model.latitude,model.longitude,model.address];
    [_mapView addAnnotation:animatedAnnotation];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }

    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationVC *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationVC alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    //自定义泡泡视图
    ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
    ((BMKPinAnnotationView*)annotationView).paopaoView = [self customBMKPaoPaoView];
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }

    annotationView.annotationImages = images;
    if ([flag isEqualToString:@"1"]) {
        titleIndex ++;
        annotationView.titlLabel.text = [NSString stringWithFormat:@"%ld",(long)titleIndex ];
    }
    else {
        annotationView.titlLabel.text = nil;
    }

    return annotationView;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)createLeftNavButton {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_rightBtn setImage:[UIImage imageNamed:@"ic_drawer"] forState:UIControlStateNormal];
        
        [_rightBtn setImage:[UIImage imageNamed:@"ic_drawer"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)rightBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (self.popView.isShow) {
            return;
        }
        [self.popView showInKeyWindow];
    }
    else {
        if (!self.popView.isShow) {
            return;
        }
        [self.popView dismissFromKeyWindow];
    }
}

#pragma mark - 定义弹出泡泡视图
- (BMKActionPaopaoView *)customBMKPaoPaoView {
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    //设置弹出气泡图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grxg_bg"]];
    image.frame = CGRectMake(0, 0, 250, 100);
    [popView addSubview:image];
    //自定义显示的内容
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 245,100)];
    driverName.text = title;
    driverName.backgroundColor = [UIColor clearColor];
    driverName.font = [UIFont systemFontOfSize:13];
    driverName.textColor = [UIColor blackColor];
    driverName.numberOfLines = 0;
    [popView addSubview:driverName];
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 250, 100);
    return pView;
}


#pragma mark - 定位
- (void)getCurrentLoaction {
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"submitcommand.htm?deviceid=%@&command=128&cmdvaluex=0&cmdvaluex=0",userModel.defaultDeVice];
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil successBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        [SVProgressHUD showWithStatus:@"加载成功"];
    } failureBlock:^(NSError *error){
        
    }];
}
@end
