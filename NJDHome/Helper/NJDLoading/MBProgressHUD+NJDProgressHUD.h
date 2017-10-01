//
//  MBProgressHUD+NJDProgressHUD.h
//  CSleepDolphin
//
//  Created by JustinYang on 2017/9/21.
//  Copyright © 2017年 HET. All rights reserved.
//

//这个category，重写activityView
#import "MBProgressHUD.h"

@interface MBProgressHUD (NJDProgressHUD)
/**
 *  给自定义的activityView赋值颜色
 */
@property (nonatomic) UIColor *activityColor;
@end
