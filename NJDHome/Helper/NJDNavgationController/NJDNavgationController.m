//
//  NJDNavgationController.m
//  NJDHome
//
//  Created by JustinYang on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NJDNavgationController.h"

@interface NJDNavgationController ()<UIGestureRecognizerDelegate>

@end

@implementation NJDNavgationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航栏背景色
    [self.navigationBar setBarTintColor:[UIColor purpleColor]];
    
    // 导航栏控件着色
    [self.navigationBar setTintColor: [UIColor whiteColor]];
    
    // Translucent
    [self.navigationBar setTranslucent: NO];
    
    // 导航栏文本属性，颜色，字体等
    [self.navigationBar setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor whiteColor],
       NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-CondensedBlack"
                                            size: 18],
       }
     ];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count > 1) {
        return YES;
    }else{
        return NO;
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}



@end
