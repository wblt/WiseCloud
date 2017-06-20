//
//  ShouhuanViewController.m
//  MVVM
//
//  Created by 冷婷 on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ShouhuanViewController.h"

@interface ShouhuanViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourX;

@end

@implementation ShouhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.width.constant = kScreenWidth*4;
    self.secondX.constant = kScreenWidth;
    self.thridX.constant = kScreenWidth*2;
    self.fourX.constant = kScreenWidth*3;
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
