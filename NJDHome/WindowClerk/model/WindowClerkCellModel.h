//
//  WindowClerkCellModel.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindowClerkCellModel : NSObject


@property (nonatomic, copy) NSString * acceptDate ;
@property (nonatomic, copy) NSString * address ;                        //地址
@property (nonatomic, copy) NSString * bidDate;
@property (nonatomic, copy) NSString * consigneeAddress ;
@property (nonatomic, copy) NSArray * didPigPaths ;    //资料照片地址
@property (nonatomic, copy) NSArray * facePigPaths ;   //人脸照片地址
@property (nonatomic, copy) NSString * recordid ;
@property (nonatomic, copy) NSArray * idCardPigPaths ;                 // 身份证地址


@property (nonatomic, copy) NSString *recordId;               //记录id
@property (nonatomic, copy) NSString * state ;                //0租户提交，1办理中，2办理完成，-1退回
@property (nonatomic, copy) NSString * submitDateTime ;               //提交时间
@property (nonatomic, copy) NSString * submitUserId ;
@property (nonatomic, copy) NSString *takeType ;        //1是邮寄到付，0是自取  2是什么？
@property (nonatomic, copy) NSString *telephoneNumber ;      //电话号码



@property (nonatomic, strong) PersonInfo *person;    //申请人  姓名，户籍地址，身份证号，

@end
