//
//  ModifyPswVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ModifyPswVC.h"

@interface ModifyPswVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@end

@implementation ModifyPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self createBackNavWithOpaque:YES];
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
    self.userNameTextFeild.placeholder = [NJDUserInfoMO userInfo].username;
    self.userNameTextFeild.enabled = NO;
    
    @weakify(self);
    RACSignal *enableSignal =
    RAC(self.comfirmBtn,enabled) =
    [RACSignal combineLatest:
     @[self.oldPwdTextFeild.rac_textSignal,
       self.pwdNewTextField.rac_textSignal,
       self.pwdNewAgainTextField.rac_textSignal]
       reduce:^id(NSString *oldPwd,
                  NSString *pwd,
                  NSString *pwdAgian){
                   return @((oldPwd.length>0&&pwd.length>0&&pwdAgian.length));
                                                               }];
    [enableSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.comfirmBtn.backgroundColor = [UIColor redColor];
        }else{
            self.comfirmBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createBackNavWithOpaque:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)comfirmHandle:(id)sender {
    if([self invilidPassword] == NO){
        return;
    }
    [NJDPopLoading showMessageWithLoading:@"正在修改"];
    [NetworkingManager changePasswordWithOld:self.oldPwdTextFeild.text
                                         new:self.pwdNewTextField.text
                                       phone:nil
             success:^(NSDictionary * _Nullable dictValue) {
                 [NJDPopLoading hideHud];
                 [NJDPopLoading showAutoHideWithMessage:@"修改成功"];
                 [self.navigationController
                  popToRootViewControllerAnimated:YES];
                 [NJDUserInfoMO userInfo].isLogin = NO;
                                     }
                 failure:^(NSError * _Nullable error) {
                     [NJDPopLoading hideHud];
                     [NJDPopLoading showAutoHideWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
                 }];
}

-(BOOL)invilidPassword{
    if ([self.pwdNewTextField.text length] < 6) {
        [NJDPopLoading showAutoHideWithMessage:@"密码长度需要大于等于6个字符"];
        return NO;
    }
    if (![self.pwdNewTextField.text isEqualToString:self.pwdNewTextField.text]) {
        [NJDPopLoading showAutoHideWithMessage:@"两次输入新密码不一致"];
        return NO;
    }
    if ([self.oldPwdTextFeild.text isEqualToString:self.pwdNewTextField.text]) {
        [NJDPopLoading showAutoHideWithMessage:@"新旧密码不能一致"];
        return NO;
    }
    return YES;
}

@end
