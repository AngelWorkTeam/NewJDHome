//
//  IDCardVC.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/1.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCardVC : NJDBaseController

@property (nonatomic,copy) void (^idCardImg)(UIImage *img);
@end
