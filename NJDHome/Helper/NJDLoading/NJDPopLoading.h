//
//  HETSleepPopLoading.h
//  CSleepDolphin
//
//  Created by JustinYang on 2017/9/22.
//  Copyright © 2017年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  在非白色背景下，loading是白色的activity，无矩形框
 *  在白色背景下， loading是5e5e5e颜色的activity，无矩形框
 *  所有带文字的loading框activity是5e5e5e(海豚睡眠中带文字的loading无activity,只有文字)，有矩形框
 *  公共模块也使用此loading框，都是有矩形，activity为5e5e5e颜色(若有activity，
 *  公共模块中一些错误提示只有文字，无activity)
 */
@interface NJDPopLoading : NSObject
/**
 *  弹出白色的loading框，无矩形
 *  下面的几个函数请直接参考函数名称
 *
 *  @return 返回的MBProgressHUD，可以根据MBProgressHUD的属性做更多自定义设置
 */
+(MBProgressHUD *)showLoading;
+(MBProgressHUD *)showLoadingAtView:(UIView *)view;
+(MBProgressHUD *)showDarkLoading;
+(MBProgressHUD *)showDarkLoadingAtView:(UIView *)view;

+(MBProgressHUD *)showMessage:(NSString *)msg;
+(MBProgressHUD *)showMessage:(NSString *)msg atView:(UIView *)view;
+(MBProgressHUD *)showMessageWithLoading:(NSString *)msg;
+(MBProgressHUD *)showMessageWithLoading:(NSString *)msg atView:(UIView *)view;

+(MBProgressHUD *)showAutoHideWithMessage:(NSString *)msg;

+(void)hideHud;
+(void)hideHudForView:(UIView *)view;
@end
