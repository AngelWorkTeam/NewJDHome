//
//  UserInfo.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoleInfo.h"
#import "PersonInfo.h"

typedef NS_ENUM(NSInteger, SexType) {
    Female = 0,//女性
    Male   = 1,//男性
};

typedef NS_ENUM(NSInteger, RoleType) {
    Role_LandLord = 0,//房东
    Role_Renter = 1,//租客
    Role_WindowClerk = 2,//窗口人员
    Role_TrafficAssistant = 3,//协管员
};

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userId;    //  用户id

@property (nonatomic, copy) NSString *userName;   //用户名（也是登陆账号）

@property (nonatomic, copy) NSString *userPassword;

@property (nonatomic, copy) NSString *realName;   //真实姓名

@property (nonatomic, assign) BOOL isDeleted;   //用户是否删除

@property (nonatomic, assign) BOOL isLocked;  //用户是否锁定

@property (nonatomic, strong) RoleInfo *role;  // 角色

@property (nonatomic, copy) NSString * regionManagement;  //辖区   非必须传递

@property (nonatomic, copy) NSString * regionManagementId ;  // 辖区id 非必须传递

@property (nonatomic, copy) NSString *   oldAddress ; //用户地址

@end
