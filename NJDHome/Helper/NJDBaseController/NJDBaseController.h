//
//  NJDBaseController.h
//  NJDHome
//
//  Created by JustinYang on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJDBaseController : UIViewController
/**
 *创建有返回按钮的页面，由子类自行调用
 * parma opaque 导航栏是否透明
 */
-(void)createBackNavWithOpaque:(BOOL)opaque;
/**
 *创建无返回按钮的页面
 */
-(void)createNoBackWithOpaue:(BOOL)opaque;
@end
