//
//  AppDelegate.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


+ (AppDelegate *)sharedApplicationDelegate;

//- (void)loginSuccessWithUserType:(RoleType)role;

@end

