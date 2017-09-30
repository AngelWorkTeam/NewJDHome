//
//  UserInfo.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userPassword;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic, assign) BOOL isLocked;



@end
