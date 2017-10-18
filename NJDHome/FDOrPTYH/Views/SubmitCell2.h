//
//  SubmitCell2.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitCell.h"

typedef NS_ENUM(NSInteger,PickType) {
    PickTypeDate,
    PickTypeCustom,
    PickTypeAddr,
};
@interface SubmitCell2 : SubmitCell
@property (nonatomic) PickType pickType;
@property (nonatomic) NSArray *dataSource;
//如果是PickTypeDate则返回日期，如果是PickTypeCustom，
//则返回选择的index，如果是租客地址，则返回regionId
//PickTypeDate和PickTypeCustom选择的内容还会通过基类cell回调返回出去
@property (nonatomic,copy) void (^selectInfo)(NSString *selectInfo);
@end
