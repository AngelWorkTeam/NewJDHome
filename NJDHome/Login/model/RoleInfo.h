//
//  RoleInfo.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleInfo : NSObject

@property (nonatomic, copy) NSString *roleId;

@property (nonatomic, assign) BOOL isSystem;

@property (nonatomic, copy) NSString *roleName;

@property (nonatomic, copy) NSString *no;  //角色名称，分协管员 XGY，房东 FD和流动人口


@end
