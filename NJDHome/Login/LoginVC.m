//
//  ViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "LoginVC.h"
#import "TrafficAssistantViewController.h"
#import "WindowClerkViewController.h"
NSString *const kRemeberPasswordKey = @"remeberPassword";
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *remeberPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initViews];
    [self configViewModel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNoBackWithOpaue:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initViews{
    [self createNoBackWithOpaue:NO];
    NJDUserInfoMO *info = [NJDUserInfoMO userInfo];
    if (info) {
        self.account.text = info.username;
        NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey:kRemeberPasswordKey];
        if ([flag boolValue]) {
            self.passwordText.text = info.userPassword;
        }
        self.remeberPwdBtn.selected = [flag boolValue]?YES:NO;
    }else{
        self.remeberPwdBtn.selected = YES;
    }
}
-(void)configViewModel{
    @weakify(self);
    RACSignal *enableSignal =
    RAC(self.loginBtn,enabled)
    = [RACSignal
       combineLatest:@[self.account.rac_textSignal,self.passwordText.rac_textSignal]
       reduce:^id(NSString *account, NSString *password){
           return @((account.length > 0 && password.length > 0));
       }];
    [enableSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            self.loginBtn.backgroundColor = [UIColor redColor];
        }else{
            self.loginBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
}
- (IBAction)remberPwdHandle:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)loginHandle:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.remeberPwdBtn.selected) forKey:kRemeberPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [NJDPopLoading showMessageWithLoading:@"正在登录"];
    if (self.account.text.length > 0 &&
        self.passwordText.text.length > 0) {
        [NetworkingManager loginWithUsername:self.account.text
                                    password:self.passwordText.text
                                     success:^(NSDictionary * _Nullable dic) {
                                         [NJDPopLoading hideHud];
                                         if ([[dic valueForKeyPath:@"result.success"] intValue] == 1) {
                                             [NJDUserInfoMO deleteAll];
                                             NJDUserInfoMO *info = [NJDUserInfoMO MR_createEntity];
                                             info.isLogin = YES;
                                             info.token = [dic valueForKeyPath:@"appLoginedInfo.token"];
                                             info.userId = [dic valueForKeyPath:@"appLoginedInfo.userId"];
                                             info.username = [dic valueForKeyPath:@"appLoginedInfo.user.username"];
                                             info.realName = [dic valueForKeyPath:@"appLoginedInfo.user.realName"];
                                             info.isdeleted = [[dic valueForKeyPath:@"appLoginedInfo.user.isDeleted"] intValue];
                                             info.isLocked = [[dic valueForKeyPath:@"appLoginedInfo.user.isLocked"] intValue];
                                             info.userPassword = self.passwordText.text;
                                             info.id = [dic valueForKeyPath:@"appLoginedInfo.user.id"];
                                             
                                             NSDictionary *role = [dic valueForKeyPath:@"appLoginedInfo.user.role"];
                                             if (role) {
                                                 info.role = [NJDRoleInfoMO MR_createEntity];
                                                 info.role.id = role[@"id"];
                                                 info.role.isSystem = [role[@"isSystem"] boolValue];
                                                 info.role.name = role[@"name"];
                                                 info.role.no = role[@"no"];
                                             }else{
                                                 info.isLogin = NO;
                                             }
                                 
                                             [NJDUserInfoMO save];
                                             
                                             if (info.isLogin) {
                                                 
                                                 if ([info.role.no isEqualToString:@"PTYH"]||
                                                     [info.role.no isEqualToString:@"FD"]) {
                                                     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                     LoginVC *vc = [sb instantiateViewControllerWithIdentifier:@"FDOrPTYHVC"];
                                                     [self.navigationController pushViewController:vc animated:YES];
                                                 }else if([info.role.no isEqualToString:@"XGY"] //协管员
                                                          ){ //窗口管理员
                                                     UIViewController *xgyviewController = [[TrafficAssistantViewController alloc]init];
                                    
                                                     [self.navigationController pushViewController:xgyviewController animated:YES];
                                                     
                                                 }else if ([info.role.no isEqualToString:@"CKRY"]){
                                                     UIViewController *ckryvc = [[WindowClerkViewController alloc]init];
                                                     [self.navigationController pushViewController:ckryvc animated:YES];
                                                 }

                                               
                                             }
                                         }
   
                                         
                                         
                                     }
                                     failure:^(NSError * _Nullable error) {
                                         [NJDPopLoading hideHud];
                                         [NJDPopLoading showAutoHideWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
                                     }];
    }
}

- (IBAction)registerHandle:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"请选择"
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    __weak UIAlertController *weakAlert = alert;
    __weak typeof (self) weakSelf = self;
    void (^pushToRegisterVC)(NSString *type) = ^(NSString *type){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RegisterVC *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterVC"];
        vc.role = type;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"我是房东"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          pushToRegisterVC(@"FD");
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"我是租客"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          pushToRegisterVC(@"PTYH");
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          [weakAlert dismissViewControllerAnimated:YES completion:nil];
                      }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
