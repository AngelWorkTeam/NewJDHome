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

@end
