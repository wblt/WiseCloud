//
//  TestUserViewController.m
//  HuiJianKang
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "TestUserViewController.h"

@interface TestUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameFiled;


@property (weak, nonatomic) IBOutlet UITextField *hightFiled;


@property (weak, nonatomic) IBOutlet UITextField *yaoweiFiled;


@property (weak, nonatomic) IBOutlet UITextField *tunweiFiled;


@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;


@property (weak, nonatomic) IBOutlet UIButton *manButton;

@property (weak, nonatomic) IBOutlet UIButton *wuMan;

@end

@implementation TestUserViewController {
    NSString *sex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑用户";
    sex = @"0";
}

- (IBAction)sexSelect:(id)sender {
    _manButton.selected = !_manButton.selected;
    _wuMan.selected = !_wuMan.selected;
    if (_manButton.selected) {
        sex = @"0";
    }
    else {
        sex = @"1";
    }
}

- (IBAction)submit:(id)sender {
    /*
     addQNuser.htm?phone=13620208169&qnuser=[%7B'name':'ZmdoaA%253D%253D','sex':'1','dateofbirth':'2016-10-12','height':'170','waist':'50','hip':'50'%7D]
     */
    if (_nameFiled.text.length == 0 || _hightFiled.text.length == 0 || _yaoweiFiled.text.length == 0 || _tunweiFiled.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"信息填写不完整"];
        return;
    }
    
    
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    
    NSString *base64Name = [[GTMBase64 encodeBase64String:_nameFiled.text] stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* timeStr = [dateFormatter stringFromDate:_pickerDate.date];
    

    NSArray *ss = @[@{@"name":base64Name,@"sex":sex,@"dateofbirth":timeStr,@"height":_hightFiled.text,@"waist":_yaoweiFiled.text,@"hip":_tunweiFiled.text}];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:ss options:0 error:nil];
    
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"addQNuser.htm?phone=%@&qnuser=%@",userModel.userPhoneNum,myString];

    [NetRequestClass requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
    }];
}
@end
