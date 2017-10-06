//
//  PersonInfo.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "PersonInfo.h"

@implementation PersonInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newingAddress"  : @"newAddress",
             };
}

@end
