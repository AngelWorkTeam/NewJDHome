//
//  ViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ViewController.h"
#import "RegisterVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createNoBackWithOpaue:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginHandle:(id)sender {
    if (self.account.text.length > 0 &&
        self.passwordText.text.length > 0) {
        [NetworkingManager loginWithUsername:self.account.text
                                    password:self.passwordText.text
                                     success:^(NSDictionary * _Nullable dic) {
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
                                             [NJDUserInfoMO save];
                                         }
   
                                         
                                         
                                     }
                                     failure:^(NSError * _Nullable error) {
                                         
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
    void (^pushToRegisterVC)(RoleType type) = ^(RoleType type){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RegisterVC *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterVC"];
        vc.role = type;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"我是房东"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          pushToRegisterVC(Role_LandLord);
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"我是租客"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          pushToRegisterVC(Role_Renter);
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          [weakAlert dismissViewControllerAnimated:YES completion:nil];
                      }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
