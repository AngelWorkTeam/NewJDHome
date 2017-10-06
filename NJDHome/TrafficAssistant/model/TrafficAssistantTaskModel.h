//
//  TrafficAssistantTaskModel.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficAssistantTaskModel : NSObject



@property (nonatomic, copy) NSString * acceptDateTime ;
@property (nonatomic, copy) NSString * acceptState ;
@property (nonatomic, copy) NSString * acceptUserId;
@property (nonatomic, copy) NSString * acceptUserName ;
@property (nonatomic, copy) NSString * companyName ;
@property (nonatomic, copy) NSString * education ;
@property (nonatomic, strong) NSArray * facePigPaths ;
@property (nonatomic, copy) NSString * faith ;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSArray * idCardPigPaths ;
@property (nonatomic, copy) NSString * inTime ;
@property (nonatomic, copy) NSString * jobTitleGrade ;
@property (nonatomic, copy) NSString *landlordIDCard ;
@property (nonatomic, copy) NSString *landlordId ;
@property (nonatomic, copy) NSString *landlordName ;
@property (nonatomic, copy) NSString *landlordPhone ;
@property (nonatomic, copy) NSString *pengikutNum ;

@property (nonatomic, copy) NSString * personTypeName ;
@property (nonatomic, copy) NSString * politicsState ;
@property (nonatomic, copy) NSString * profession ;
@property (nonatomic, copy) NSString * regionId ;
@property (nonatomic, copy) NSString * relativeRecordId ;
@property (nonatomic, copy) NSString * roomNumber ;
@property (nonatomic, copy) NSString * state ;
@property (nonatomic, copy) NSString *submitDateTime ;
@property (nonatomic, copy) NSString *submitUserId ;
@property (nonatomic, copy) NSString *telephoneNumber ;
@property (nonatomic, copy) NSString * temporaryAddress;
@property (nonatomic, copy) NSString * type ;

@end
