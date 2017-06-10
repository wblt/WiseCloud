//
//  PersonalViewController.m
//  HuiJianKang
//
//  Created by 冷婷 on 16/5/29.
//  Copyright © 2016年 cn.hi-watch. All rights reserved.
//

#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface PersonalViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;

@end

@implementation PersonalViewController {
    UIImagePickerController *imagePicker;
    UIImage *originalImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人";
    
    self.headImg.layer.cornerRadius = 45;
    
    self.headImg.layer.masksToBounds = YES;
    
    NSData *imgData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"headImge"] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (imgData != nil) {
        UIImage *heaimg = [UIImage imageWithData:imgData];
        self.headImg.image = heaimg;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.headImg.userInteractionEnabled = YES;
    [self.headImg addGestureRecognizer:tap];

    [NetRequestClass requestURL:[NSString stringWithFormat:@"seeMemberByLoginname.htm?phone=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNum"]] httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        //创建用户模型对象
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *arr = data;
            NSDictionary *dic = arr[0];
            _telLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNum"];
            _nikeName.text = [NSString stringWithFormat:@"%@",dic[@"nikename"]];
            _nameLabel.text = [NSString stringWithFormat:@"%@  %@岁",[dic[@"sex"] integerValue]==0?@"男":@"女",dic[@"age"]];
        }else {
//            [self showError:@"服务器错误"];
        }
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
    }];
    [NetRequestClass requestURL:[NSString stringWithFormat:@"getMemberImg.htm?deviceid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNum"]] httpMethod:kGET params:nil file:nil successBlock:^(id data) {
        //创建用户模型对象
        
        if ([data isKindOfClass:[NSString class]]) {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:@"head_portrait"]];
        }else {
            //暂时隐藏掉
//            [self showError:@"头像获取失败"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitAction:(id)sender {
    if (self.nickField.text.length > 10 ) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能超过10位"];
        return;
    }
    
    NSInteger age = [self.ageField.text integerValue];
    if (age > 200) {
        [SVProgressHUD showErrorWithStatus:@"年龄不能超过200岁"];
        return;
    }
    
    NSString *base64Name = [[GTMBase64 encodeBase64String:_nickField.text] stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    //确认修改接口
    if ([self.nickField.text length]>0&&[self.ageField.text length]>0) {
        NSString *urlStr = [NSString stringWithFormat:@"updateMember.htm?phone=%@&nikename=%@&sex=%@&age=%@",_telLabel.text,base64Name,_manBtn.selected?@"0":@"1",_ageField.text];
        [NetRequestClass requestURL:urlStr httpMethod:kGET params:nil file:nil successBlock:^(id data) {
            //创建用户模型对象
            NSInteger num = [data integerValue];
            if (num == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.5];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }
        } failureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请填写完整"];
    }
}
- (IBAction)resetAction:(id)sender {
    self.nickField.text = nil;
    self.ageField.text = nil;
}
- (IBAction)exitUser:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVC = [storyboad instantiateInitialViewController];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = loginVC;
}
- (IBAction)sexSelect:(UIButton *)sender {
    _manBtn.selected = !_manBtn.selected;
    _womenBtn.selected = !_womenBtn.selected;
}


- (void)tapAction:(UIGestureRecognizer *)ges {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择照片", @"拍照片", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if (buttonIndex == 0) {/**<相册库选取照片*/
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1){/**<拍照选取照片*/
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                  message:@"设备不支持拍照功能"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            [myAlertView show];
            return;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else if (buttonIndex == 2){
        
        return ;
    }
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
//相册处理，获取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {/**<选中照片回调*/
    
    originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    
    self.headImg.image = originalImage;
    
    NSData *imgdata = UIImageJPEGRepresentation(originalImage, 0.8);
    [[NSUserDefaults standardUserDefaults] setObject: [[NSString alloc] initWithData:imgdata  encoding:NSUTF8StringEncoding] forKey:@"headImge"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self requestModifyHeadImg];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {/**<不选照片点击取消回调*/
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
