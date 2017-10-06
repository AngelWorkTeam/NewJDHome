//
//  TrafficAssistantTaskModel.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAssistantTaskModel.h"

@implementation TrafficAssistantTaskModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"person" : [PersonInfo class]};
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"recordId"  : @"id",
             };
}

@end
