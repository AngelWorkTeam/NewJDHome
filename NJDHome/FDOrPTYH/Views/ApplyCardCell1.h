//
//  ApplyCardCell1.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/5.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitCell.h"
@interface ApplyCardCell1 :SubmitCell
@property (nonatomic,copy) void (^changeAddr)(NSString *townId,NSString *regionId, NSString *addr);
@end
