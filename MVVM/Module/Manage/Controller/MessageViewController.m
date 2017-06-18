//
//  MessageViewController.m
//  MVVM
//
//  Created by 冷婷 on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commit;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.layer.borderColor = [UIColor orangeColor].CGColor;
    _textView.layer.borderWidth = 2;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.text = @"请输入意见...";
    _textView.delegate = self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入意见..."]) {
        textView.text = @"";
    }
    return YES;
}
- (IBAction)commitAction:(id)sender {
    [self.textView resignFirstResponder];
    NSString *base64 = [GTMBase64 encodeBase64String:self.textView.text];
    UserModel *userModel = [[UserConfig shareInstace] getAllInformation];
    NSString *urlString = [NSString stringWithFormat:@"insertopinion.htm?username=%@&option=%@",userModel.userPhoneNum,base64];
    [NetRequestClass afn_requestURL:urlString httpMethod:kGET params:nil  successBlock:^(id data) {
//        NSInteger value = [data integerValue];
        //if (value == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2];
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:@"提交失败"];
//        }
        
    } failureBlock:^(NSError *error) {
        
    }];
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
