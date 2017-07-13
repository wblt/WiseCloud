//
//  AddDeviceController.m
//  MVVM
//
//  Created by wb on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AddDeviceController.h"
#import "AddDeviceViewController.h"

@interface AddDeviceController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation AddDeviceController {
    NSString *identify;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.dataArr addObject:@"手表"];
    [self.dataArr addObject:@"手杖"];
    [self.dataArr addObject:@"手环"];
    [self.dataArr addObject:@"体脂称"];
    [self.dataArr addObject:@"水分仪"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    identify = @"UITableViewCell";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArr[indexPath.row];
    if ([title isEqualToString:@"手表"]) {
        AddDeviceViewController *add = [[AddDeviceViewController alloc] initWithNibName:@"AddDeviceViewController" bundle:nil];
        [self.navigationController pushViewController:add animated:YES];
    } else if ([title isEqualToString:@"手杖"]) {
        AddDeviceViewController *add = [[AddDeviceViewController alloc] initWithNibName:@"AddDeviceViewController" bundle:nil];
        [self.navigationController pushViewController:add animated:YES];
    } else {
        self.returnBlock(title);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
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
