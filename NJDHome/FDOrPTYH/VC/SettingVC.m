//
//  SettingVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self createBackNavWithOpaque:YES];
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (IBAction)modifyPwdHandle:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}
- (IBAction)logout:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                               message:@"确定要退出?"
                                preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                 @strongify(self);
                                                [NJDUserInfoMO userInfo].isLogin = NO;
                                                [NJDUserInfoMO save];
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
   
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
