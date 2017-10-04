//
//  SubmitCell4.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell.h"

@interface SubmitCell4 : SubmitCell
@property (nonatomic) NSInteger childNum;
@property (nonatomic,copy) void (^addChildInfo)(void);
@property (nonatomic,copy) void (^minsChildInfo)(void);
@end
