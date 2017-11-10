//
//  NetworkingManager.m
//  NJDHome
//
//  Created by JustinYang on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NetworkingManager.h"

#import "NetworkingConstant.h"

NSString * const kLandDomain = @"ldrk/landlordAddress/";

NSString * const kLoginPath = @"login";
NSString * const kRegister = @"regist";
NSString * const kModifyPasswork = @"updatePwd";
NSString * const kGetCode       = @"takeCode";




NSString * const kGetCitys = @"region/loadCitys";
NSString * const kGetRegions = @"region/loadDistricts";
NSString * const kGetDistrict = @"region/loadVillagesORTownsOrStreets";
NSString * const kGetTowns = @"region/loadBurgs";

NSString * const kGetHouseAdd = @"getLandlordAddressList";
NSString * const kSaveAddr    = @"saveLandlordAddress";
NSString * const kDeleteAddr = @"deleteLandlordAddress";

NSString *const kSubmitInfo = @"saveCheckInRecord";
NSString *const kApplyCard = @"saveBidInfo";
NSString *const kUnregisterRenter = @"logOutRecord";

NSString *const kPersonsByLandlordUserId = @"getPersonsByLandlordUserId";
NSString *const kChangeRecord = @"changeRecord";

@implementation NetworkingManager
+(void)printfUrl:(NSURL *)url{
    NSLog(@"req:%@",url.absoluteString);
}
+(BOOL)dealWithResponse:(NSDictionary *)reslut
                failure:(NJDHttpFailureBlock)fail{
    if(![reslut isKindOfClass:[NSDictionary class]]){
        !fail?:fail([self responseTypeError]);
        return NO;
    }
    NSString *reslutStr = reslut[@"resultMsg"];
    if ([reslutStr isEqualToString:@"操作令牌失效"]) { //直接登出
        [[NSNotificationCenter defaultCenter] postNotificationName:kTokenError object:nil];
        return NO;
    }
    if ([reslut valueForKeyPath:@"checkResult.success"]&&
        [reslut valueForKeyPath:@"checkResult.resultMsg"]&&
        [[reslut valueForKeyPath:@"checkResult.success"] boolValue] == NO){
        if ([[reslut valueForKeyPath:@"checkResult.resultMsg"] isEqualToString:@"操作令牌不存在或已过期,请重新登录"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenError object:nil];
            return NO;
        }
    }
    if (reslutStr &&
        [reslut[@"success"] boolValue] == NO) {
        NSError *err = [NSError errorWithDomain:@"response error"
                                           code:1003
                                       userInfo:@{NSLocalizedDescriptionKey:reslutStr}];
        !fail?:fail(err);
        return NO;
    }

    if ([reslut valueForKeyPath:@"result.success"] &&
        [[reslut valueForKeyPath:@"result.success"] boolValue] == NO) {
        NSError *err = [NSError errorWithDomain:@"response error"
                                           code:1004
                                       userInfo:@{NSLocalizedDescriptionKey:SAFE_STRING([reslut valueForKeyPath:@"result.resultMsg"])}];
        !fail?:fail(err);
        return NO;
    }
    if (reslut[@"checkResult"] &&
        [[reslut valueForKeyPath:@"checkResult.success"] boolValue] == NO) {
        NSError *err = [NSError errorWithDomain:@"response error"
                                           code:1005
                                       userInfo:@{NSLocalizedDescriptionKey:SAFE_STRING([reslut valueForKeyPath:@"checkResult.resultMsg"])}];
        !fail?:fail(err);
        return NO;
    }
    if ([reslut valueForKeyPath:@"accessResult.success"] &&
        [[reslut valueForKeyPath:@"accessResult.success"] boolValue] == NO) {
        NSError *err = [NSError errorWithDomain:@"response error"
                                           code:1006
                                       userInfo:@{NSLocalizedDescriptionKey:SAFE_STRING([reslut valueForKeyPath:@"accessResult.resultMsg"])}];
        !fail?:fail(err);
        return NO;
    }
    return YES;
}

+(NSError *)responseTypeError{
    NSError *err = [NSError errorWithDomain:@"response type error"
                                       code:1001
                                   userInfo:@{NSLocalizedDescriptionKey:@"服务器返回了错误的数据"}];
    return err;
}
+(AFHTTPSessionManager *)manager{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = kTimeout;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];

    });
    
    return manager;
}
+(NSString *)appendQuryStringWithUrl:(NSString *)urlStr
                              params:(NSDictionary *)params{
    if (params.allKeys.count == 0){
        return urlStr;
    }
    urlStr = [urlStr stringByAppendingString:@"?"];
    __block NSString * blockStr = urlStr;
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        blockStr = [blockStr stringByAppendingString:key];
        blockStr = [blockStr stringByAppendingString:@"="];
        blockStr = [blockStr stringByAppendingFormat:@"%@",obj];
        blockStr = [blockStr stringByAppendingString:@"&"];
    }];
    if(blockStr.length > 2){
        blockStr = [blockStr substringToIndex:blockStr.length-1];
    }
    return [blockStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+(AFHTTPSessionManager *)loginWithUsername:(nonnull NSString *)username
                                  password:(NSString *)password
                                   success:(NJDHttpSuccessBlockDictionary)success
                                   failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *manager = [self manager];
    NSString *url = [self appendQuryStringWithUrl:kURL(kUserDomain, kLoginPath) params:@{@"username":SAFE_STRING(username),
                                                                                         @"password":SAFE_STRING(password)
                                                                                         }];
   NSURLSessionTask *task = [manager POST:url
                              parameters:nil
                        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if ([self dealWithResponse:responseObject
                                               failure:fail] == NO) {
                                return ;
                            }
                            if([responseObject isKindOfClass:[NSDictionary class]]){
                               !success?:success(responseObject);
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            !fail?:fail(error);
                        }];
    
    [self printfUrl:task.currentRequest.URL];
    return manager;
}

+(void)registerWithParams:(NSDictionary *)params
                              success:(NJDHttpSuccessBlockDictionary)success
                              failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *manager = [self manager];
    NSMutableDictionary *dic = params.mutableCopy;
    UIImage *img = params[@"identityImgFile"];
    [dic removeObjectForKey:@"identityImgFile"];
    void (^formDataBlock)(id formData) = ^(id<AFMultipartFormData>  _Nonnull formData) {
        if (img) {
            NSData *data = UIImageJPEGRepresentation(img, 0.75);
            [formData appendPartWithFileData: data
                                        name: @"identityImgFile"
                                    fileName: @"identityImgFile.png"
                                    mimeType: @"image/png"];
        }
    };
    [manager POST:kURL(kUserDomain, kRegister)
       parameters:dic.copy
constructingBodyWithBlock:img?formDataBlock:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self dealWithResponse:responseObject failure:fail] == NO) {
                  return ;
              }
              !success?:success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
}

+(void)identifierIdWithImg:(UIImage *)img
                   success:(NJDHttpSuccessBlockArray)success
                   failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:@"https://api-cn.faceplusplus.com/cardpp/v1/ocridcard"
       parameters:@{@"api_key":kFacePlusAPIKey,
                    @"api_secret":kFacePlusAPISecret
                    }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *data = UIImageJPEGRepresentation(img, 0.75);
    [formData appendPartWithFileData: data
                                name: @"image_file"
                            fileName: @"idcard.png"
                            mimeType: @"image/png"];
        }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if([responseObject isKindOfClass:[NSDictionary class]]){
                  NSDictionary *dic = responseObject;
                  NSArray *cards = dic[@"cards"];
                  if ([cards isKindOfClass:[NSArray class]]
                      &&cards.count >0) {
                      !success?:success(cards);
                  }else{
                    !fail?:fail([NSError errorWithDomain:@"identifier fail"
                                                    code:1002
                                                userInfo:@{NSLocalizedDescriptionKey:@"解析失败了"}]);
                  }
                  
              }else{
                  !fail?:fail([self responseTypeError]);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
}

+(void)changePasswordWithOld:(NSString *)oldPassword
                         new:(NSString *)newPassword
                       phone:(NSString *)phone
                     success:(NJDHttpSuccessBlockDictionary)success
                     failure:(NJDHttpFailureBlock)fail{
    NSDictionary *params;
    if (oldPassword) {
        params = @{@"oldPWD":oldPassword,
                   @"newPWD":newPassword,
                   @"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                   };
    }else{
        params = @{@"newPWD":newPassword,
                   @"phoneNum":phone
                   };
    }
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionTask *task = [manager POST:kURL(kUserDomain, kModifyPasswork)
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self dealWithResponse:responseObject
                   failure:fail] == NO) {
                  return ;
              }
              !success?:success(responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
    [self printfUrl:task.currentRequest.URL];
}

+(void)getCodeWithPhone:(NSString *)phone
                success:(NJDHttpSuccessBlockDictionary)success
                failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m POST:kURL(kUserDomain, kGetCode)
                          parameters:@{@"phoneNum":phone}
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 !success?:success(responseObject);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}






+(void)getLandLordAddressSuccess:(NJDHttpSuccessBlockArray)success
                         failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m GET:kURL(kLandDomain, kGetHouseAdd)
                          parameters:@{@"userId":SAFE_STRING([NJDUserInfoMO userInfo].userId),
                                       @"token":SAFE_STRING([NJDUserInfoMO userInfo].token)}

                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 if ([self dealWithResponse:responseObject
                                                    failure:fail] == NO) {
                                     return ;
                                 }
                                 NSArray *arr = responseObject[@"landlordAddresses"];
                                 !success?:success(arr);

                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 !fail?:fail(error);
                             }];
    [self printfUrl:task.currentRequest.URL];
}


+(void)getCitys:(NJDHttpSuccessBlockArray)success
                 failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kGetCitys)
                         parameters:nil
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (![responseObject isKindOfClass:[NSArray class]]) {
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

+(void)getRegions:(NSString *)regionId
             success:(NJDHttpSuccessBlockArray)success
        failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kGetRegions)
                         parameters:@{@"cityRegionId":regionId}
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (![responseObject isKindOfClass:[NSArray class]]) {
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

+(void)getGetDistrics:(NSString *)districtRegionId
          success:(NJDHttpSuccessBlockArray)success
          failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kGetDistrict)
                         parameters:@{@"districtRegionId":districtRegionId}
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (![responseObject isKindOfClass:[NSArray class]]) {
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

+(void)getGetTowns:(NSString *)townId
              success:(NJDHttpSuccessBlockArray)success
              failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kGetTowns)
                         parameters:@{@"townId":townId}
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (![responseObject isKindOfClass:[NSArray class]]) {
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

+(void)landLordAddAddress:(NSString *)regionId
            address:(NSString *)address
           success:(NJDHttpSuccessBlockDictionary)success
           failure:(NJDHttpFailureBlock)fail{
           AFHTTPSessionManager *m = [self manager];
       
    NSURLSessionTask *task = [m GET:kURL(kLandDomain, kSaveAddr)
                         parameters:@{@"regionId":regionId,
                                      @"userId":SAFE_STRING([NJDUserInfoMO userInfo].userId),
                                      @"token":SAFE_STRING([NJDUserInfoMO userInfo].token),
                                      @"address":address
                                      }
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if([self dealWithResponse:responseObject failure:fail] == NO){
                                    return ;
                                }
                                !success?:success(responseObject);
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                !fail?:fail(error);
                            }];
    [self printfUrl:task.currentRequest.URL];
}

+(void)landLordDeleteAddress:(NSString *)regionId
                  success:(NJDHttpSuccessBlockDictionary)success
                  failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m GET:kURL(kLandDomain, kDeleteAddr)
                         parameters:@{@"id":regionId,
                                      @"token":SAFE_STRING([NJDUserInfoMO userInfo].token)
                                      }
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if([self dealWithResponse:responseObject failure:fail] == NO){
                                    return ;
                                }
                                !success?:success(responseObject);
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                !fail?:fail(error);
                            }];
    [self printfUrl:task.currentRequest.URL];
}

+(void)submitWithInfo:(NSDictionary *)params
            idCardImg:(UIImage *)idCardImg
           renterImgs:(NSArray *)imgs
              success:(NJDHttpSuccessBlockDictionary)success
              failure:(NJDHttpFailureBlock)fail{
    NSMutableDictionary *dic = params.mutableCopy;
    dic[@"token"] = SAFE_STRING([NJDUserInfoMO userInfo].token);
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = 60;
    NSString *url = [self
                     appendQuryStringWithUrl: kURL(kUserDomain, kSubmitInfo)
                           params:dic.copy];
    [manager POST:url
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = UIImageJPEGRepresentation(idCardImg, 0.75);
         [formData appendPartWithFileData: data
                                     name: @"identityImgFile"
                                 fileName: @"identityImgFile.png"
                                 mimeType: @"image/png"];
        for (UIImage *img in imgs) {
            NSData *data = UIImageJPEGRepresentation(img, 0.75);
            NSString *fileName = [NSString stringWithFormat:@"%@.png",@(arc4random())];
            [formData appendPartWithFileData: data
                                        name: @"photoImgFiles"
                                    fileName: fileName
                                    mimeType: @"image/png"];
        }
     }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self dealWithResponse:responseObject failure:fail] == NO) {
                  return ;
              }
              !success?:success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
    manager.requestSerializer.timeoutInterval = 30;
}

+(void)applyCard:(NSDictionary *)params
            idCardImg:(UIImage *)idCardImg
           dataImgs:(NSArray *)imgs
         faceImg:(UIImage *)faceImg
              success:(NJDHttpSuccessBlockDictionary)success
              failure:(NJDHttpFailureBlock)fail{
    NSMutableDictionary *dic = params.mutableCopy;
    dic[@"token"] = SAFE_STRING([NJDUserInfoMO userInfo].token);
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = 60;
    [manager POST:kURL(kUserDomain, kApplyCard)
       parameters:dic.copy
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *data = UIImageJPEGRepresentation(idCardImg, 0.75);
    [formData appendPartWithFileData: data
                                name: @"identityImgFile"
                            fileName: @"identityImgFile.png"
                            mimeType: @"image/png"];
    data = UIImageJPEGRepresentation(faceImg, 0.75);
    [formData appendPartWithFileData: data
                                name: @"faceImgFiles"
                            fileName: @"faceImgFiles.png"
                            mimeType: @"image/png"];
    for (UIImage *img in imgs) {
        NSData *data = UIImageJPEGRepresentation(img, 0.75);
        NSString *fileName = [NSString stringWithFormat:@"%@.png",@(arc4random())];
        [formData appendPartWithFileData: data
                                    name: @"photoImgFiles"
                                fileName: fileName
                                mimeType: @"image/png"];
    }
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self dealWithResponse:responseObject failure:fail] == NO) {
                  return ;
              }
              !success?:success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
    manager.requestSerializer.timeoutInterval = 30;
}

+(void)unRegisterRender:(NSDictionary *)params
              idCardImg:(UIImage *)idCardImg
                success:(NJDHttpSuccessBlockDictionary)success
                failure:(NJDHttpFailureBlock)fail{
    NSMutableDictionary *dic = params.mutableCopy;
    dic[@"token"] = SAFE_STRING([NJDUserInfoMO userInfo].token);
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = 60;
    [manager POST:kURL(kUserDomain, kUnregisterRenter)
       parameters:dic.copy
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *data = UIImageJPEGRepresentation(idCardImg, 0.75);
    [formData appendPartWithFileData: data
                                name: @"identityImgFile"
                            fileName: @"identityImgFile.png"
                            mimeType: @"image/png"];
    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([self dealWithResponse:responseObject failure:fail] == NO) {
                  return ;
              }
              !success?:success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              !fail?:fail(error);
          }];
    manager.requestSerializer.timeoutInterval = 30;
}

+(void)getPersonsRecordWithPage:(NSInteger)page
                        success:(NJDHttpSuccessBlockArray)success
                        failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kPersonsByLandlordUserId)
                         parameters:@{@"page":@(page),
                                      @"token":SAFE_STRING([NJDUserInfoMO userInfo].token),
                                      @"userId":SAFE_STRING([NJDUserInfoMO userInfo].userId)
                                      }
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if([self dealWithResponse:responseObject failure:fail] == NO){
                                    return ;
                                }
                                NSArray *arr = responseObject[@"records"];
                                !success?:success(arr);
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                !fail?:fail(error);
                            }];
    [self printfUrl:task.currentRequest.URL];
}

+(void)changeRecord:(NSString *)recordId
         changeState:(NSInteger)state
               room:(NSString *)roomNum
                        success:(NJDHttpSuccessBlockDictionary)success
                        failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *m = [self manager];
    
    NSURLSessionTask *task = [m GET:kURL(kUserDomain, kChangeRecord)
                         parameters:@{@"recordId":recordId,
                                      @"token":SAFE_STRING([NJDUserInfoMO userInfo].token),
                                      @"roomNumber":roomNum,
                                      @"type":@(state)
                                      }
                           progress:nil
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if([self dealWithResponse:responseObject failure:fail] == NO){
                                    return ;
                                }
                                !success?:success(responseObject);
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                !fail?:fail(error);
                            }];
    [self printfUrl:task.currentRequest.URL];
}

@end
