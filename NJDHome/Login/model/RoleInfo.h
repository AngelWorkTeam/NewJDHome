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

@property (nonatomic, copy) NSString *no;


@end
