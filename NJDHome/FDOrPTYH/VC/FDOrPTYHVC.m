//
//  FDOrPTYHVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "FDOrPTYHVC.h"
#import "SettingVC.h"
@interface FDOrPTYHVC ()

@end

@implementation FDOrPTYHVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNoBackWithOpaue:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privte metod
-(void)initViews{
    [self createNoBackWithOpaue:YES];
    self.title = @"新金东人之家";
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"设置" style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                             action:@selector(settingHandle:)];
}

#pragma mark - action handle
-(void)settingHandle:(UIBarButtonItem *)item{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingVC *vc =[sb instantiateViewControllerWithIdentifier:@"settingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tapApplyView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.view.tag == 1000) {
            
        }else if(sender.view.tag == 1002){
            
        }
    }
}

@end
