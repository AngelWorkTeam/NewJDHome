//
//  AppDelegate.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "AppDelegate+Login.h"
#import "TrafficAssistantViewController.h"
#import "LandlordViewController.h"
#import "RenterViewController.h"
#import "WindowClerkViewController.h"
#import "NJDNavgationController.h"
#import "WindowClerkViewController.h"
#define kToken @"token"

@interface AppDelegate ()
@property (nonatomic, copy) NSString *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Setup MagivalRecord & CoreData
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self creatRootVC];

    
    [self.window makeKeyAndVisible];
//
//    [Bugly startWithAppId:@"02841f4dd3"];
    
    [self startObserveLoginOut];
    return YES;
}


+ (AppDelegate *)sharedApplicationDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)loginSuccessWithUserType:(RoleType)role
{
//    Role_LandLord = 0,//房东
//    Role_Renter = 1,//租客
//    Role_WindowClerk = 2,//窗口人员
//    Role_TrafficAssistant = 3,//协管员
    switch (role) {
        case Role_LandLord:
            [self toLandLord];
            break;
        case Role_Renter:
            [self toRenter];
            break;
        case Role_WindowClerk:
            [self toWindowClerk];
            break;
        case Role_TrafficAssistant:
            [self toTrafficAssistant];
            break;
    }
    
}

// 登录
- (void)toSignin
{
    // 登录 viewController
    UIStoryboard *sportStoryBoard =  [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *controller = [sportStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    self.window.rootViewController = controller;
}

-(NJDNavgationController *)creatRootVC
{
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *login = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
    NJDNavgationController *nav = [[NJDNavgationController alloc] initWithRootViewController:login];
    NJDUserInfoMO *userInfo = [NJDUserInfoMO userInfo];
    if (userInfo.isLogin&&
        userInfo.role.no) {//可以根据角色设置推入哪两个VC了(登入界面总在nav中)
        if ([userInfo.role.no isEqualToString:@"PTYH"]||
            [userInfo.role.no isEqualToString:@"FD"]) {
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FDOrPTYHVC"];
            [nav setViewControllers:@[login,vc]];
        }else if([userInfo.role.no isEqualToString:@"XGY"] //协管员
        ){ //窗口管理员
            UIViewController *xgyviewController = [[TrafficAssistantViewController alloc]init];
            [nav setViewControllers:@[login, xgyviewController]];
        }else if ([userInfo.role.no isEqualToString:@"CKRY"]){
            UIViewController *xgyviewController = [[WindowClerkViewController alloc]init];
            [nav setViewControllers:@[login, xgyviewController]];
        }
    }
    
    return nav;
}

// 窗口人员
- (void)toWindowClerk
{
    // 登录 viewController
    
    
    WindowClerkViewController *vc = [WindowClerkViewController new];
    
    UINavigationController *nav =  [[UINavigationController alloc]initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
}

// 协管员
- (void)toTrafficAssistant
{
    // 登录 viewController
    TrafficAssistantViewController *viewController =  [TrafficAssistantViewController new];
    
    self.window.rootViewController = viewController;
}

// 租客
- (void)toRenter
{

}

// 房东
- (void)toLandLord
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
