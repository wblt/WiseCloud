//
//  RecordViewController.m
//  MVVM
//
//  Created by 周后云 on 17/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RecordViewController.h"
#import "DateCell.h"
@interface RecordViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *lastBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *dateTable;
@property (weak, nonatomic) IBOutlet UITableView *deteilTable;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateTable.dataSource = self;
    _dateTable.delegate = self;
    _dateTable.rowHeight = 60;
    _dateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deteilTable.dataSource = self;
    _deteilTable.delegate = self;
    _deteilTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dateTable registerNib:[UINib nibWithNibName:@"DateCell" bundle:nil] forCellReuseIdentifier:@"datecell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dateTable) {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datecell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.date.text = @"09.09";
        return cell;
    }else if (tableView == _deteilTable) {
        static NSString *CellIdentifier = @"deteilcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = @"体重";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"bmi"];
        cell.detailTextLabel.text = @"48.5kg";
        cell.detailTextLabel.textColor = [UIColor greenColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lastBtn.frame = CGRectMake(135, 20, 20, 20);
    lastBtn.layer.cornerRadius = 10;
    lastBtn.layer.masksToBounds = YES;
    if (tableView == _dateTable) {
        DateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.budgeBtn.frame = CGRectMake(160-30, 15, 30, 30);
        cell.budgeBtn.layer.cornerRadius = 15;
        cell.budgeBtn.layer.masksToBounds = YES;
        lastBtn = cell.budgeBtn;
    }
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
