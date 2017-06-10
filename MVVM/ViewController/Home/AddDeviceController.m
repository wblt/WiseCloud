//
//  AddDeviceController.m
//  MVVM
//
//  Created by wb on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AddDeviceController.h"

@interface AddDeviceController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation AddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return nil;
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
