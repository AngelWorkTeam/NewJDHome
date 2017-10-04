//
//  DayPicker.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayPicker : UIView
@property (nonatomic,copy) void (^selectDay)(NSString *);
@end
