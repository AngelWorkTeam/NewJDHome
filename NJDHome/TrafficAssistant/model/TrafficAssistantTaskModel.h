//
//  TrafficAssistantTaskModel.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonInfo.h"
@interface TrafficAssistantTaskModel : NSObject



@property (nonatomic, copy) NSString * acceptDateTime ;
@property (nonatomic, copy) NSString * acceptState ;
@property (nonatomic, copy) NSString * acceptUserId;
@property (nonatomic, copy) NSString * acceptUserName ;
@property (nonatomic, copy) NSString * companyName ;
@property (nonatomic, copy) NSString * education ;                //education
@property (nonatomic, strong) NSArray * facePigPaths ;
@property (nonatomic, copy) NSString * faith ;                 // 信仰
@property (nonatomic, copy) NSString *recordId;               //education
@property (nonatomic, strong) NSArray * idCardPigPaths ;
@property (nonatomic, copy) NSString * inTime ;               //申报时间
@property (nonatomic, copy) NSString * jobTitleGrade ;
@property (nonatomic, copy) NSString *landlordIDCard ;
@property (nonatomic, copy) NSString *landlordId ;
@property (nonatomic, copy) NSString *landlordName ;
@property (nonatomic, copy) NSString *landlordPhone ;
@property (nonatomic, copy) NSString *pengikutNum ;

@property (nonatomic, copy) NSString * personTypeName ;   // personTypeName 
@property (nonatomic, copy) NSString * politicsState ;  //政治面貌
@property (nonatomic, copy) NSString * profession ;    //职业
@property (nonatomic, copy) NSString * regionId ;               // 辖区ID
@property (nonatomic, copy) NSString * relativeRecordId ;
@property (nonatomic, copy) NSString * roomNumber ;           // 房间号
@property (nonatomic, copy) NSString * state ;                //-1退回0待派工1已派工待受理2已受理待登记3已完成登记
@property (nonatomic, copy) NSString * submitDateTime ;
@property (nonatomic, copy) NSString * submitUserId ;
@property (nonatomic, copy) NSString * telephoneNumber ;      // 电话号码
@property (nonatomic, copy) NSString * temporaryAddress;     // 暂住地址
@property (nonatomic, copy) NSString * type ;                 //申报类型1申报，2变更，0注销

@property (nonatomic, strong) PersonInfo *person;

@end
