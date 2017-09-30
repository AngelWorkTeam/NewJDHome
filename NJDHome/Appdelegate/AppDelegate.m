//
//  AppDelegate.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "TrafficAssistantViewController.h"
#import "LandlordViewController.h"
#import "RenterViewController.h"
#import "WindowClerkViewController.h"
#import "NJDNavgationController.h"
#define kToken @"token"

@interface AppDelegate ()
@property (nonatomic, copy) NSString *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self creatRootVC];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.token = [defaults objectForKey:kToken];//token关键字对应的对象
//
//    if(self.token!=nil)//不为空时执行
//    {
//        // 拿到缓存的用户类型，跳转想要的用户类型
//
//        [self loginSuccessWithUserType:Role_TrafficAssistant];
//    }
//    else//为空时登录
//    {
//        [self toSignin];
//    }
    [self.window makeKeyAndVisible];
   
    // 4.添加bugly检测
    //    AppID：
    //    02841f4dd3
    //    AppKey：
    //    fe6785a7-0265-4954-a066-9f238ef1c839
    [Bugly startWithAppId:@"02841f4dd3"];

    
   
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
    UIStoryboard *sportStoryBoard =  [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *controller = [sportStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    NJDNavgationController *nav = [[NJDNavgationController alloc] initWithRootViewController:controller];
    return nav;
}

// 窗口人员
- (void)toWindowClerk
{
    // 登录 viewController
    UIStoryboard *sportStoryBoard =  [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *controller = [sportStoryBoard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    
    self.window.rootViewController = controller;
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
