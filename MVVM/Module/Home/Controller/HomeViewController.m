//
//  HomeViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HomeViewController.h"

#import "NoticePhotoSelectCell.h"

#import <ImagePlayerView/ImagePlayerView.h>

#import "AddDeviceController.h"

#import "BraceletSearchController.h"

#import "ShouhuanViewController.h"

#import "TargetViewController.h"

#import "WristFunctionModel.h"

@interface HomeViewController ()<ImagePlayerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CXXPhotoCellDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) ImagePlayerView *imgPlayerView;

@property (nonatomic, strong) NSArray *imageURLs;

@property (nonatomic,strong) WristFunctionModel *functionModel;

/** 最大可选择图片个数 */
@property (nonatomic, assign) NSInteger maxImageCount;

/** 选择的图片数据源 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HomeViewController {
    UICollectionView *_collectionView;
    CGFloat _itemWH;
    CGFloat _margin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadData];
    
    self.maxImageCount = 9;
    
    [self initScrollView];
    
    // 初始化 师徒
    [self initBannerView];
    
    //初始化collectionView
    [self initCollectionView];
    
}

// 加载数据
- (void)loadData {
    [SVProgressHUD showWithStatus:@"数据加载中"];
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlStr = [NSString stringWithFormat:@"getWristWatchFunction.htm?deviceid=%@&phone=%@",userModel.defaultDeVice,userModel.userPhoneNum];
    [NetRequestClass afn_requestURL:urlStr httpMethod:kGET params:nil successBlock:^(id returnValue) {
        [SVProgressHUD dismiss];
        if (![returnValue isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSDictionary *dicData = (NSDictionary *)returnValue;
        self.functionModel = [WristFunctionModel mj_objectWithKeyValues:dicData];
        [self.dataArr removeAllObjects];
        NSLog(@"%@",self.functionModel);
        [self.scrollView.mj_header endRefreshing];
        [self showFunctionList:self.functionModel];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"加载失败"];
        [SVProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    }];
    
}

// 添加滑动视图
- (void)initScrollView {
    // 1.创建UIScrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // frame中的size指UIScrollView的可视范围
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    __weak typeof(self) weakSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 加载数据
        [weakSelf loadData];
    }];
}

- (void)initCollectionView {
    _collectionView = [self.view viewWithTag:201];
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (self.view.frame.size.width - 2 * _margin - 4) / 4 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 110, self.view.frame.size.width - 2 * _margin, self.view.frame.size.height - 150) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.tag = 201;
        
        CGFloat height = ((self.dataArr.count + 3) / 3 ) * (_margin + _itemWH);
        
        _collectionView.height = height + 4;
        
        [self.scrollView addSubview:_collectionView];
        
        [_collectionView registerClass:[NoticePhotoSelectCell class] forCellWithReuseIdentifier:@"NoticePhotoSelectCell"];
    }
}


- (void)initBannerView {
    
    self.imgPlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [self.scrollView addSubview:self.imgPlayerView];
    
    self.imageURLs = @[[NSURL URLWithString:@"http://sudasuta.com/wp-content/uploads/2013/10/10143181686_375e063f2c_z.jpg"],
                       [NSURL URLWithString:@"http://img01.taopic.com/150920/240455-1509200H31810.jpg"],
                       [NSURL URLWithString:@"http://img.taopic.com/uploads/allimg/110906/1382-110Z611025585.jpg"]];
    
    self.imgPlayerView.imagePlayerViewDelegate = self;

    // set auto scroll interval to x seconds
    self.imgPlayerView.scrollInterval = 1.0f;
    
    // adjust pageControl position
    self.imgPlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    
    // hide pageControl or not
    self.imgPlayerView.hidePageControl = NO;
    
    // endless scroll
    self.imgPlayerView.endlessScroll = YES;
    
//    // adjust edgeInset
//    self.imgPlayerView.edgeInsets = UIEdgeInsetsMake(10, 20, 30, 40);
    [self.imgPlayerView reloadData];
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.image = [UIImage imageNamed:@"bg1"];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoticePhotoSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoticePhotoSelectCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.row == self.dataArr.count) {
        cell.imageView.image = [UIImage imageNamed:@"addnum.png"];
        cell.closeButton.hidden = YES;
    } else {
        NSString *title = self.dataArr[indexPath.row];
        if ([title isEqualToString:@"手环"]) {
            UIImage *img = [UIImage imageNamed:@"shouhuan"];
            cell.imageView.image = img;
        } else if ([title isEqualToString:@"体脂称"]) {
            UIImage *img = [UIImage imageNamed:@"gndg9"];
            cell.imageView.image = img;
        } else if ([title isEqualToString:@"水分仪"]) {
            UIImage *img = [UIImage imageNamed:@"gndg13dd"];
            cell.imageView.image = img;
        } else if([title isEqualToString:@"位置"]) {
            UIImage *img = [UIImage imageNamed:@"gndg3"];
            cell.imageView.image = img;
        } else {
            UIImage *img = [UIImage imageNamed:@"gndg15-2"];
            cell.imageView.image = img;
        }
        cell.closeButton.hidden = NO;
    }
    return cell;
}

//设置单元格的起始位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, -2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataArr.count) {
        AddDeviceController *addDev = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceController"];
        addDev.returnBlock = ^(NSString *returnValue) {
            if ([self detechItem:returnValue]) {
                [self.dataArr removeObject:returnValue];
            } else {
                [self.dataArr addObject:returnValue];
            }
            [self reloadData];
        };
        addDev.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addDev animated:YES];
    }
    else {
        NSString *title = self.dataArr[indexPath.row];
        if ([title isEqualToString:@"手环"]) {
            ShouhuanViewController *ShouhuanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShouhuanViewController"];
            ShouhuanVC.hidesBottomBarWhenPushed = YES;
            // ShouhuanVC.bleModel = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:ShouhuanVC animated:YES];
            
//            BraceletSearchController *BraceletVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BraceletSearchController"];
//            BraceletVC.hidesBottomBarWhenPushed = YES;
//            BraceletVC.type = self.dataArr[indexPath.row];
//            [self.navigationController pushViewController:BraceletVC animated:YES];
        } else if([title isEqualToString:@"血压"]) {
            
        }
        else if([title isEqualToString:@"心率"]) {
            
        }
        else if([title isEqualToString:@"心电图"]) {
            
        }
        else if([title isEqualToString:@"睡眠"]) {
            
        }
        else if([title isEqualToString:@"血糖"]) {
            
        }
        else if([title isEqualToString:@"位置"]) {
            
        }
        else if([title isEqualToString:@"运动"]) {
            
        }
        else if([title isEqualToString:@"氧气"]) {
            
        }
        else if([title isEqualToString:@"状态"]) {
            
        }
        else if([title isEqualToString:@"体温"]) {
            
        }
        else if([title isEqualToString:@"体脂称"]) {
            BraceletSearchController *BraceletVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BraceletSearchController"];
            BraceletVC.hidesBottomBarWhenPushed = YES;
            BraceletVC.type = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:BraceletVC animated:YES];
        }
        else if([title isEqualToString:@"水分仪"]) {
            BraceletSearchController *BraceletVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BraceletSearchController"];
            BraceletVC.hidesBottomBarWhenPushed = YES;
            BraceletVC.type = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:BraceletVC animated:YES];
        }
    }

}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)reloadData{
    // 大于maxImageCount条的删除
    if (self.dataArr.count > self.maxImageCount) {
        NSRange range = NSMakeRange(self.maxImageCount, self.dataArr.count - self.maxImageCount);
        [self.dataArr removeObjectsInRange:range];
    }
    [_collectionView reloadData];
    
    CGFloat height = ((self.dataArr.count + 3) / 3 ) * (_margin + _itemWH);
    
    if (height > self.view.height - 150) {
        _collectionView.height = self.view.height - 150;
    }
    else {
        _collectionView.height = height + 4;
    }
    _collectionView.contentSize = CGSizeMake(0, ((self.dataArr.count + 2) / 3 ) * (_margin + _itemWH));
}

// 显示功能列表
- (void)showFunctionList:(WristFunctionModel *)functionModel {
    // 血压
    if ([functionModel.bloodpressure isEqualToString:@"true"]) {
        [self.dataArr addObject:@"血压"];
    } else {
        if ([self detechItem:@"血压"]) {
            [self.dataArr removeObject:@"血压"];
        }
    }
    
    // 心率
    if ([functionModel.heartrate isEqualToString:@"true"]) {
        [self.dataArr addObject:@"心率"];
    } else {
        if ([self detechItem:@"心率"]) {
            [self.dataArr removeObject:@"心率"];
        }
    }

    // 心电图
    if ([functionModel.ecg isEqualToString:@"true"]) {
        [self.dataArr addObject:@"心电图"];
    } else {
        if ([self detechItem:@"心电图"]) {
            [self.dataArr removeObject:@"心电图"];
        }
    }
    
    // 睡眠
    if ([functionModel.sleep isEqualToString:@"true"]) {
        [self.dataArr addObject:@"睡眠"];
    } else {
        if ([self detechItem:@"睡眠"]) {
            [self.dataArr removeObject:@"睡眠"];
        }
    }
    
    // 血糖
    if ([functionModel.Bloodglucose isEqualToString:@"true"]) {
        [self.dataArr addObject:@"血糖"];
    } else {
        if ([self detechItem:@"血糖"]) {
            [self.dataArr removeObject:@"血糖"];
        }
    }
    
    // 位置
    if ([functionModel.position isEqualToString:@"true"]) {
        [self.dataArr addObject:@"位置"];
    } else {
        if ([self detechItem:@"位置"]) {
            [self.dataArr removeObject:@"位置"];
        }
    }
    
    // 运动
    if ([functionModel.sport isEqualToString:@"true"]) {
        [self.dataArr addObject:@"运动"];
    } else {
        if ([self detechItem:@"运动"]) {
            [self.dataArr removeObject:@"运动"];
        }
    }
    
    // 氧气
    if ([functionModel.oxygen isEqualToString:@"true"]) {
        [self.dataArr addObject:@"氧气"];
    } else {
        if ([self detechItem:@"氧气"]) {
            [self.dataArr removeObject:@"氧气"];
        }
    }
    
    // 状态
    if ([functionModel.status isEqualToString:@"true"]) {
        [self.dataArr addObject:@"状态"];
    } else {
        if ([self detechItem:@"状态"]) {
            [self.dataArr removeObject:@"状态"];
        }
    }
    
    // 体温
    if ([functionModel.temperature isEqualToString:@"true"]) {
        [self.dataArr addObject:@"体温"];
    } else {
        if ([self detechItem:@"体温"]) {
            [self.dataArr removeObject:@"体温"];
        }
    }
    
    // 体脂称
    if ([functionModel.bodyFat isEqualToString:@"true"]) {
        [self.dataArr addObject:@"体脂称"];
    } else {
        if ([self detechItem:@"体脂称"]) {
            [self.dataArr removeObject:@"体脂称"];
        }
    }
    
    // 水分子
    if ([functionModel.water isEqualToString:@"true"]) {
        [self.dataArr addObject:@"水分仪"];
    } else {
        if ([self detechItem:@"水分仪"]) {
            [self.dataArr removeObject:@"水分仪"];
        }
    }
    
    // Y2
    if ([functionModel.y2bracelet isEqualToString:@"true"]) {
        [self.dataArr addObject:@"手环"];
    } else {
        if ([self detechItem:@"手环"]) {
            [self.dataArr removeObject:@"手环"];
        }
    }
    
    // 刷新显示
    [self reloadData];
}


/**
 * 检测是否有这个数据
 */
- (BOOL)detechItem:(NSString *)title {
    if ([self.dataArr containsObject:title]) {
        return YES;
    }
    return false;
}
@end
