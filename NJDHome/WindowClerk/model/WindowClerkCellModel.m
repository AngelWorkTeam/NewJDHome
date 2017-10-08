//
//  WindowClerkCellModel.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowClerkCellModel.h"

@implementation WindowClerkCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"person" : [PersonInfo class],
             @"didPigPaths" : [NSArray class],
             @"facePigPaths" : [NSArray class],
             @"idCardPigPaths" : [NSArray class],};
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"recordId"  : @"id",
             };
}


@end
