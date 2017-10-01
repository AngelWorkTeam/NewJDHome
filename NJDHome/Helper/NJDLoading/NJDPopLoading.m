//
//  HETSleepPopLoading.m
//  CSleepDolphin
//
//  Created by JustinYang on 2017/9/22.
//  Copyright © 2017年 HET. All rights reserved.
//

#import "NJDPopLoading.h"
#import "MBProgressHUD+NJDProgressHUD.h"
@implementation NJDPopLoading

+(MBProgressHUD *)showLoading{
    return [NJDPopLoading showWithLoading:YES
                                          dark:NO
                                  hasRectangle:NO
                                       message:nil
                                        atView:nil
                                    hiderAfter:0];
}
+(MBProgressHUD *)showLoadingAtView:(UIView *)view{
    return [NJDPopLoading showWithLoading:YES
                                          dark:NO
                                  hasRectangle:NO
                                       message:nil
                                        atView:view
                                    hiderAfter:0];
}
+(MBProgressHUD *)showDarkLoading{
    return [NJDPopLoading showWithLoading:YES
                                          dark:YES
                                  hasRectangle:NO
                                       message:nil
                                        atView:nil
                                    hiderAfter:0];
}
+(MBProgressHUD *)showDarkLoadingAtView:(UIView *)view{
    return [NJDPopLoading showWithLoading:YES
                                          dark:YES
                                  hasRectangle:NO
                                       message:nil
                                        atView:view
                                    hiderAfter:0];
}

+(MBProgressHUD *)showMessage:(NSString *)msg{
    return [NJDPopLoading showWithLoading:NO
                                          dark:YES
                                  hasRectangle:YES
                                       message:msg
                                        atView:nil
                                    hiderAfter:0];
}
+(MBProgressHUD *)showMessage:(NSString *)msg atView:(UIView *)view{
    return [NJDPopLoading showWithLoading:NO
                                          dark:YES
                                  hasRectangle:YES
                                       message:msg
                                        atView:view
                                    hiderAfter:0];
}
+(MBProgressHUD *)showMessageWithLoading:(NSString *)msg{
    return [NJDPopLoading showWithLoading:YES
                                          dark:YES
                                  hasRectangle:YES
                                       message:msg
                                        atView:nil
                                    hiderAfter:0];
}
+(MBProgressHUD *)showMessageWithLoading:(NSString *)msg atView:(UIView *)view{
    return [NJDPopLoading showWithLoading:YES
                                          dark:YES
                                  hasRectangle:YES
                                       message:msg
                                        atView:view
                                    hiderAfter:0];
}

+(MBProgressHUD *)showAutoHideWithMessage:(NSString *)msg;{
    return [NJDPopLoading showWithLoading:NO
                                          dark:NO
                                  hasRectangle:YES
                                       message:msg
                                        atView:nil
                                    hiderAfter:1.5];
}

+(void)hideHud{
    [ NJDPopLoading hideHudForView:[UIApplication sharedApplication].keyWindow];
    
}
+(void)hideHudForView:(UIView *)view{
//    [MBProgressHUD hideHUDForView:view animated:YES];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
+(MBProgressHUD *)showWithLoading:(BOOL)loading
                             dark:(BOOL)dark
                     hasRectangle:(BOOL)hasRectangle
                          message:(NSString *)msg
                           atView:(UIView *)view
                       hiderAfter:(CGFloat)showDuration{
    UIView *parentView = nil;
    if (view == nil) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }else{
        parentView = view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    if (loading == NO) {
        hud.mode = MBProgressHUDModeText;
    }
    if (dark) {
        
        hud.activityColor = [UIColor sam_colorWithHex:@"5e5e5e"];
    }
    if (hasRectangle == NO) {
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
    }
    if (msg) {
        hud.label.text = msg;
        hud.label.numberOfLines = 0;
    }
    if (showDuration > 0.01) {
        [hud hideAnimated:YES afterDelay:showDuration];
    }
 
    return hud;
}
@end
