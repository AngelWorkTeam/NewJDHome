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
