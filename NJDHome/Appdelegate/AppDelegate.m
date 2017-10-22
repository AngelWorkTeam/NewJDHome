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

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#define JPUSHAppKey  @""
#define JPUSHChannel @"appStore"

static const BOOL isProduction = false;

@interface AppDelegate ()<JPUSHRegisterDelegate>
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
    [self initJPUSH:launchOptions];
    
    [self startObserveLoginOut];
    return YES;
}


+ (AppDelegate *)sharedApplicationDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}


- (void)initJPUSH:(NSDictionary *)launchOptions
{
    //添加初始化APNs代码
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //添加初始化JPush代码
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:JPUSHChannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
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


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
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
