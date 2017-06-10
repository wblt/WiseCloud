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

@interface HomeViewController ()<ImagePlayerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CXXPhotoCellDelegate>

@property (weak, nonatomic) IBOutlet ImagePlayerView *imgPlayerView;

@property (nonatomic, strong) NSArray *imageURLs;

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
    
    // 初始化 师徒
    [self initBannerView];
    
    //初始化collectionView
    [self initCollectionView];
    
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 214, self.view.frame.size.width - 2 * _margin, self.view.frame.size.height - 150) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.tag = 201;
        
        CGFloat height = ((self.dataArr.count + 3) / 3 ) * (_margin + _itemWH);
        
        _collectionView.height = height + 4;
        
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[NoticePhotoSelectCell class] forCellWithReuseIdentifier:@"NoticePhotoSelectCell"];
    }
}



- (void)initBannerView {
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
    // recommend to use SDWebImage lib to load web image
    //    [imageView setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:nil];
    
    NSURL *imageURL = [self.imageURLs objectAtIndex:index];
    [imageView sd_setImageWithURL:imageURL placeholderImage:nil];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoticePhotoSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoticePhotoSelectCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == self.dataArr.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.closeButton.hidden = YES;
    } else {
        cell.imageView.image = self.dataArr[indexPath.row];
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
    AddDeviceController *addDev = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceController"];
    addDev.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addDev animated:YES];
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
