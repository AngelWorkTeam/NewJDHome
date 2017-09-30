//
//  NJDBaseController.m
//  NJDHome
//
//  Created by JustinYang on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NJDBaseController.h"
#import <objc/runtime.h>
#import <SAMCategories/SAMCategories.h>

@interface NJDBaseController ()

@end

@implementation NJDBaseController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];

 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

-(void)createBackNavWithOpaque:(BOOL)opaque{
    if (!self.navigationItem.leftBarButtonItem) {
        [self createBackButton];
    }
    if (opaque) {
        [self opaqueNavigationBar];
    }else{
        [self transparentNavigationBar];
    }
}
-(void)createNoBackWithOpaue:(BOOL)opaque{
    self.navigationItem.leftBarButtonItem = nil;
    if (opaque) {
        [self opaqueNavigationBar];
    }else{
        [self transparentNavigationBar];
    }
        
}
// 统一 Back 按钮的处理
- (void)createBackButton{
    
    UIImage *backImage = [UIImage imageNamed:@"HETSleepCoreNavBack"];
    CGRect frame = CGRectMake(0, 0, 44, 44);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = frame;
    [backButton setImage: backImage forState:UIControlStateNormal];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
}

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}



-(UIStatusBarStyle)statusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)enablePopGesture{
    return YES;
}

@end
