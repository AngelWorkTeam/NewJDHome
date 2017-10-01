//
//  RegisterVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/1.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UIButton *scanIdBtn;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackNavWithOpaque:YES];
    [self initViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
-(void)initViews{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.scanIdBtn.layer.cornerRadius = 6.;
    self.scanIdBtn.layer.masksToBounds = YES;
    
}

@end
