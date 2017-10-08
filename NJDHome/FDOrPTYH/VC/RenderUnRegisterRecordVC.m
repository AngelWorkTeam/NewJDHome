//
//  RenderUnRegisterRecordVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/7.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RenderUnRegisterRecordVC.h"
#import "UnregisterVC.h"
@interface RenderUnRegisterRecordVC ()

@end

@implementation RenderUnRegisterRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
}
-(void)initViews{
    [self createBackNavWithOpaque:YES];
    self.title = @"房客变更注销申报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(pushToUnregisterVC:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushToUnregisterVC:(UIBarButtonItem *)item{
    UnregisterVC *vc = [UnregisterVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
