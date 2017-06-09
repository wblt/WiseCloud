//
//  HomeViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HomeViewController.h"

#import <ImagePlayerView/ImagePlayerView.h>

@interface HomeViewController ()<ImagePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet ImagePlayerView *imgPlayerView;

@property (nonatomic, strong) NSArray *imageURLs;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    // 初始化 师徒
    [self initBannerView];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
