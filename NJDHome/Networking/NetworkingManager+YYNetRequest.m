//
//  NetworkingManager+YYNetRequest.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NetworkingManager+YYNetRequest.h"
#import "NetworkingConstant.h"





NSString * const kGetRecordToXGY       = @"getRecordListToXGY";

NSString * const kTrafficAccept        = @"acceptCheckRecord";

NSString * const kregisterRecord       = @"registerRecord";

NSString * const kcareOfRecord         = @"careOfRecord";

NSString * const kgetListToCKRY        = @"getListToCKRY";

NSString * const kchangeBidState       = @"changeBidState";

NSString * const kgetRecordListBySubmitUserIdk = @"getRecordListBySubmitUserId";

NSString * const kgetListByPersonId     = @"getListByPersonId";


@implementation NetworkingManager (YYNetRequest)


// yy add code
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
                   ,@"recordFlag":@"done"
                   };
    }else{
        parms  = @{@"userId":userId
                   ,@"page":@(page)
                   ,@"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   ,@"recordFlag":@"wait"
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

// 18.	协管员--受理：
+(void)trafficAcceptTheRecordWithRecordId:(NSString *_Nullable)recordId
                         success:(NJDHttpSuccessBlockDictionary)success
                         failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];

    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kTrafficAccept)
                          parameters:@{@"userId":recordId
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

// 协管员—申报登记（注销登记，变更登记）
+(void)trafficRegisterRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   personTypeName:(NSString *)personTypeName
                                  success:(NJDHttpSuccessBlockDictionary)success
                                  failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kTrafficAccept)
                          parameters:@{@"userId":recordId
                                       ,@"personTypeName":personTypeName
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

// 协管员—申报登记（注销登记，变更登记）
+(void)trafficCareOfRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   changeUserId:(NSString *)changeUserId
                                          success:(NJDHttpSuccessBlockDictionary)success
                                          failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kcareOfRecord)
                          parameters:@{@"userId":recordId
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


//  sendBackRecord
// 协管员—申报登记（注销登记，变更登记）
+(void)trafficSendBackRecordTheRecordWithRecordId:(NSString *_Nullable)recordId
                                   sendBckContext:(NSString *)sendBckContext
                                        success:(NJDHttpSuccessBlockDictionary)success
                                        failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kcareOfRecord)
                          parameters:@{@"userId":recordId
                                       ,@"sendBckContext":sendBckContext
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



// yy windowtraffic
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


//  sendBackRecord
// 窗口人员—退回 受理
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

//  getRecordListBySubmitUserId
// 流动人口查询记录  房东也是这个接口
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

//  getRecordListBySubmitUserId
// IC
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


@end
