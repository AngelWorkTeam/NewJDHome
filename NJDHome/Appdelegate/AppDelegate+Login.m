//
//  AppDelegate+Login.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "AppDelegate+Login.h"

@implementation AppDelegate (Login)
-(void)startObserveLoginOut{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logintOutHandle:)
         name:kTokenError
                   object:nil];
}
-(void)stopObserveLoginOut{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:kTokenError
     object:nil];
}

-(void)logintOutHandle:(NSNotification *)noti{
    [NJDPopLoading hideHud];
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        if(nav.viewControllers.count > 1){
            [nav popToRootViewControllerAnimated:YES];
            [NJDUserInfoMO userInfo].isLogin = NO;
        }
    }
}
@end
