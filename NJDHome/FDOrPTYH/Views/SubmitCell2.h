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
@end
