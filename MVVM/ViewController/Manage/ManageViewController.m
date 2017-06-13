//
//  ManageViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ManageViewController.h"
#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MyDeviceViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "MessageViewController.h"
#import "RecordViewController.h"
@interface ManageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *manageArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理";
    _logoutBtn.layer.cornerRadius = 5;
    _logoutBtn.layer.masksToBounds = YES;
    manageArr = @[@"个人",@"设备",@"帮助",@"关于",@"意见反馈"];
    _tableView.scrollEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageCell" forIndexPath:indexPath];
    cell.textLabel.text = manageArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.row == 0) {
        PersonalViewController *personal = [[PersonalViewController alloc] init];
        personal.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personal animated:YES];
        
    }else if (indexPath.row == 1) {
        MyDeviceViewController *mydevice = [[MyDeviceViewController alloc] init];
        mydevice.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mydevice animated:YES];
    }else if (indexPath.row == 2) {
        HelpViewController *help = [[HelpViewController alloc] init];
        help.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:help animated:YES];
    }else if (indexPath.row == 3) {
        AboutViewController *about = [[AboutViewController alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }else if (indexPath.row == 4) {
        MessageViewController *ShouhuanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        ShouhuanVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ShouhuanVC animated:YES];
    }*/
    
    RecordViewController *ShouhuanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
    ShouhuanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ShouhuanVC animated:YES];
}

- (IBAction)logoutAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhoneNum"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultDeVice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVC = [storyboad instantiateInitialViewController];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = loginVC;
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
