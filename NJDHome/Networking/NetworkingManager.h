//
//  NetworkingManager.h
//  NJDHome
//
//  Created by JustinYang on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>




typedef void (^NJDHttpSuccessBlockEmpty)(void);
typedef void (^NJDHttpSuccessBlockId)(id _Nullable response);
typedef void(^NJDHttpSuccessBlockString)(NSString * _Nullable stringValue);
typedef void(^NJDHttpSuccessBlockNumber)(NSNumber * _Nullable numberValue);
typedef void(^NJDHttpSuccessBlockDictionary)(NSDictionary * _Nullable dictValue);
typedef void(^NJDHttpSuccessBlockArray)(NSArray * _Nullable arrayValue);
typedef void(^NJDHttpSuccessBlockImage)(UIImage * _Nullable image);
typedef void (^NJDHttpFailureBlock)(NSError * _Nullable error);

@interface NetworkingManager : NSObject
//login interface
+(AFHTTPSessionManager *_Nullable)loginWithUsername:(NSString *_Nonnull)username
                                           password:(NSString *_Nonnull)password
                                            success:(NJDHttpSuccessBlockDictionary _Nullable )success
                                            failure:(NJDHttpFailureBlock _Nullable )fail
;

//regist interface
+(void)registerWithParams:(NSDictionary *_Nonnull)params
                  success:(NJDHttpSuccessBlockDictionary _Nullable)success
                  failure:(NJDHttpFailureBlock _Nullable)fail;
//identify id card by face++ interface
+(void)identifierIdWithImg:(UIImage *_Nonnull)img
                   success:(NJDHttpSuccessBlockArray _Nullable)success
                   failure:(NJDHttpFailureBlock _Nullable)fail;

/**
 *修改密码或找回密码，当修改密码时，oldPassword和newPassword一定有值，phone为空
 *当找回密码时，newPassword和phone一定有值，oldPassword为空
 */
+(void)changePasswordWithOld:(NSString *_Nullable)oldPassword
                         new:(NSString *_Nonnull)newPassword
                       phone:(NSString *_Nullable)phone
                     success:(NJDHttpSuccessBlockDictionary _Nullable )success
                     failure:(NJDHttpFailureBlock _Nullable )fail;

//get verify code
+(void)getCodeWithPhone:(NSString *_Nonnull)phone
                success:(NJDHttpSuccessBlockDictionary _Nullable )success
                failure:(NJDHttpFailureBlock _Nonnull )fail;


//房东得到自己的房屋地址
+(void)getLandLordAddressSuccess:(NJDHttpSuccessBlockArray _Nullable)success
                         failure:(NJDHttpFailureBlock _Nullable)fail;
//新增地址
+(void)landLordAddAddress:(NSString *_Nonnull)regionId
                  address:(NSString *_Nonnull)address
                  success:(NJDHttpSuccessBlockDictionary _Nullable )success
                  failure:(NJDHttpFailureBlock _Nullable )fail;
//删除地址
+(void)landLordDeleteAddress:(NSString *_Nonnull)regionId
                     success:(NJDHttpSuccessBlockDictionary _Nullable )success
                     failure:(NJDHttpFailureBlock _Nullable )fail;

+(void)getCitys:(NJDHttpSuccessBlockArray _Nullable )success
        failure:(NJDHttpFailureBlock _Nullable)fail;

+(void)getRegions:(NSString *_Nonnull)regionId
          success:(NJDHttpSuccessBlockArray _Nullable)success
          failure:(NJDHttpFailureBlock _Nullable)fail;

+(void)getGetDistrics:(NSString * _Nonnull)districtRegionId
              success:(NJDHttpSuccessBlockArray _Nullable)success
              failure:(NJDHttpFailureBlock _Nullable)fail;

+(void)getGetTowns:(NSString *_Nonnull)townId
           success:(NJDHttpSuccessBlockArray _Nullable)success
           failure:(NJDHttpFailureBlock _Nullable)fail;

//本人申报，他人申报，房东为租客申报
+(void)submitWithInfo:(NSDictionary *_Nonnull)params
            idCardImg:(UIImage *_Nonnull)idCardImg
           renterImgs:(NSArray *_Nonnull)imgs
              success:(NJDHttpSuccessBlockDictionary _Nullable )success
              failure:(NJDHttpFailureBlock _Nullable )fail;


//申请居住证接口
+(void)applyCard:(NSDictionary *_Nonnull)params
       idCardImg:(UIImage *_Nonnull)idCardImg
        dataImgs:(NSArray *_Nonnull)imgs
         faceImg:(UIImage *_Nonnull)faceImg
         success:(NJDHttpSuccessBlockDictionary _Nullable )success
         failure:(NJDHttpFailureBlock _Nullable )fail;

+(void)unRegisterRender:(NSDictionary *_Nonnull)params
              idCardImg:(UIImage *_Nonnull)idCardImg
                success:(NJDHttpSuccessBlockDictionary _Nullable)success
                failure:(NJDHttpFailureBlock _Nullable )fail;
/////// for yy code

+(void)printfUrl:(NSURL *_Nonnull)url;
+(BOOL)dealWithResponse:(NSDictionary *_Nonnull)reslut
                failure:(NJDHttpFailureBlock _Nullable )fail;
+(NSError *_Nullable)responseTypeError;
+(AFHTTPSessionManager *_Nonnull)manager;

@end
