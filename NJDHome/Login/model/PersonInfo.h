//
//  PersonInfo.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfo : NSObject

@property (nonatomic, copy) NSString *personId;


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sex;    //否    用户性别1是男0是女

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *telephoneNumber;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *address;     //否    用户地址（身份证地址）

@property (nonatomic, copy) NSString * nation;   //否    用户民族

@property (nonatomic, copy) NSString *identityCard;  //否    用户身份证号
@end
