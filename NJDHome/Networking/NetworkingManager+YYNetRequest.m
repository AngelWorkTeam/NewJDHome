//
//  NetworkingManager+YYNetRequest.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NetworkingManager+YYNetRequest.h"
#import "NetworkingConstant.h"





NSString * const kgetRecordListBySubmitUserIdk = @"getRecordListBySubmitUserId";  // 11 14


NSString * const kGetRecordToXGY       = @"getRecordListToXGY";    //15

NSString * const kTrafficAccept        = @"acceptCheckRecord";  //16

NSString * const kregisterRecord       = @"registerRecord";   //17

NSString * const kcareOfRecord         = @"careOfRecord";    //18



NSString * const ksendBackRecord       = @"sendBackRecord";  //19





NSString * const kgetListByPersonId     = @"getListByPersonId";   //23

NSString * const kgetListToCKRY        = @"getListToCKRY";   //24

NSString * const kchangeBidState       = @"changeBidState";  //25

NSString * const kloadXGYList       = @"loadXGYList";  //26  高工提供的获取协管员的列表
//参数token和regionId（辖区id）


@implementation NetworkingManager (YYNetRequest)


//  14.    流动人口--申报进度查询：
//  11.    房东--申报记录查询：
// 流动人口查询记录  房东也是这个接口
//userId    是    用户id
//token    是    令牌
//page    是    页数
//type    是    类型 -1

+(void)renderGetShenbaoRecordListByPage:(NSInteger)page
                                success:(NJDHttpSuccessBlockDictionary _Nullable)success
                                failure:(NJDHttpFailureBlock _Nullable)fail{
    AFHTTPSessionManager *m = [self manager];
    NSDictionary *parms;
    
    parms  = @{@"userId":SAFE_STRING([NJDUserInfoMO userInfo].userId)
               ,@"page":@(page)
               ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
               ,@"type":@"-1"
               };
    
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kgetRecordListBySubmitUserIdk)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

// 15.    协管员--记录查询操作：
//  getRecordListToXGY
+(void)getTrafficsDataWithUserId:(NSString *)userId
                            page:(NSInteger)page
                     isNewRecord:(BOOL)isNew
                         success:(NJDHttpSuccessBlockDictionary)success
                         failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSDictionary *parms;
    if (isNew) {
        parms  = @{@"userId":userId
                   ,@"page":@(page)
                   ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   ,@"recordFlag":@"wait"
                   };
    }else{
        parms  = @{@"userId":userId
                   ,@"page":@(page)
                   ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   ,@"recordFlag":@"done"
                   };
    }
    
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kGetRecordToXGY)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

// 16.	协管员--受理：
//  acceptCheckRecord
//recordId是    记录id
//token    是    令牌
//checkDate否    核查日期
//checkTime否    核查时间
//note否    说明

+(void)trafficAcceptTheRecordWithRecordId:(NSString *)recordId
                                checkDate:(NSString *_Nullable)checkDate
                                checkTime:(NSString *_Nullable)checkTime
                                note:(NSString *_Nullable)note
                         success:(NJDHttpSuccessBlockDictionary)success
                         failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithObjectsAndKeys:recordId,@"recordId", SAFE_STRING([NJDUserInfoMO userInfo].token),@"token",nil];
    
    if (checkDate) {
        [parms setObject:checkDate forKey:@"checkDate"];
    }
    
    if (checkTime) {
        [parms setObject:checkTime forKey:@"checkTime"];
    }
    
    if (note) {
        [parms setObject:note forKey:@"note"];
    }
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kTrafficAccept)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
    
    
}

// 17.    协管员—申报登记（注销登记，变更登记）
//kregisterRecord
//recordId是    记录id
//token    是    令牌
//personTypeName是    完成情况
//note否    完成说明

+(void)trafficRegisterRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   personTypeName:(NSString *_Nullable)personTypeName
                                             note:(NSString *)note
                                  success:(NJDHttpSuccessBlockDictionary)success
                                  failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kregisterRecord)
                          parameters:@{@"recordId":recordId
                                       ,@"personTypeName":personTypeName
                                       ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                                       ,@"note":note
                                       }
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

// 18.    协管员--转交
//careOfRecord
//recordId是    记录id
//token    是    令牌
//changeUserId是    转交的协管员id

+(void)trafficCareOfRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   changeUserId:(NSString *)changeUserId
                                          success:(NJDHttpSuccessBlockDictionary)success
                                          failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kcareOfRecord)
                          parameters:@{@"recordId":recordId
                                       ,@"changeUserId":changeUserId
                                       ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                                       }
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}


//  19.    协管员—退回
// 协管员—申报登记（注销登记，变更登记）
//recordId是    记录id
//token    是    令牌
//sendBckContext是    退回内容
//qtContext否    其他

+(void)trafficSendBackRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   sendBckContext:(NSString *_Nullable)sendBckContext
                                        qtContext:(NSString *) qtContext
                                        success:(NJDHttpSuccessBlockDictionary)success
                                        failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithObjectsAndKeys:recordId,@"recordId", SAFE_STRING([NJDUserInfoMO userInfo].token),@"token",nil];
    
    [parms setObject:sendBckContext forKey:@"sendBckContext"];
    if (qtContext) {
        [parms setObject:qtContext forKey:@"qtContext"];
    }

    NSURLSessionTask *task = [m POST:kURL(kUserDomain, ksendBackRecord)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}


//  23.    IC卡居住证申请记录接口
//userId     是    用户id
//token是    令牌
//page    是    第几页

+(void)renderGetICCardRecordListByPage:(NSInteger)page
                         success:(NJDHttpSuccessBlockDictionary _Nullable)success
                         failure:(NJDHttpFailureBlock _Nullable)fail{
    AFHTTPSessionManager *m = [self manager];
    NSDictionary *parms;
    
    parms  = @{@"userId":SAFE_STRING([NJDUserInfoMO userInfo].userId)
               ,@"page":@(page)
               ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
               
               };
    
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kgetListByPersonId)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

//  acceptCheckRecord
// 25.    窗口人员退回和受理接口
//residencePermitId     是    要处理的记录id
//state     是    处理类型1是受理-1是退回int 类型
//reason     受理是空字符串    原因（如果是受理不填空字符串代替即可，退回填写退回内容）

+(void)windowAcceptAndRejectWithRecordId:(NSString *_Nullable)recordId
                                   state:(NSString *_Nullable)state
                                  reason:(NSString *_Nullable)reason
                                 success:(NJDHttpSuccessBlockDictionary)success
                                 failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kchangeBidState)
                          parameters:@{@"userId":recordId
                                       ,@"residencePermitId":recordId
                                       ,@"state":state
                                       ,@"reason":reason
                                       ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                                       }
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

//24.    获取窗口人员处理记录列表接口
//userId     是    用户id
//token     是    令牌
//page     是    第几页
//flag     是    标记（wait）此处写wait即可

//获取历史记录处理列表flag标记flag 标记写done即可
+(void)getWindowsClerkDataWithUserId:(NSString *)userId
                                page:(NSInteger)page
                         isNewRecord:(BOOL)isNew
                             success:(NJDHttpSuccessBlockDictionary)success
                             failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSDictionary *parms;
    if (isNew) {
        parms  = @{@"userId":userId
                   ,@"page":@(page)
                   ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   ,@"flag":@"wait"
                   };
    }else{
        parms  = @{@"userId":userId
                   ,@"page":@(page)
                   ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   ,@"flag":@"done"
                   };
    }
    
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kgetListToCKRY)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}

//  27.   获取辖区内窗口管理人员
//  loadXGYList
//regionId     是   辖区id
//token是    令牌


+(void)GetRegionXGYSBayRegionId:(NSString *)regionId
                               success:(NJDHttpSuccessBlockDictionary _Nullable)success
                               failure:(NJDHttpFailureBlock _Nullable)fail{
    AFHTTPSessionManager *m = [self manager];
    NSDictionary *parms;
    
    parms  = @{@"regionId":regionId
               ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
               };
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kloadXGYList)
                          parameters:parms
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 
                                 if (![responseObject isKindOfClass:[NSDictionary class]]) {
                                     !fail?:fail([self responseTypeError]);
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}
@end
