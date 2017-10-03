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

+(AFHTTPSessionManager *_Nullable)loginWithUsername:(NSString *_Nonnull)username
                                           password:(NSString *_Nonnull)password
                                            success:(NJDHttpSuccessBlockDictionary _Nullable )success
                                            failure:(NJDHttpFailureBlock _Nullable )fail
;

+(void)registerWithParams:(NSDictionary *_Nonnull)params
                  success:(NJDHttpSuccessBlockDictionary _Nullable)success
                  failure:(NJDHttpFailureBlock _Nullable)fail;
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

+(void)getCodeWithPhone:(NSString *_Nonnull)phone
                success:(NJDHttpSuccessBlockDictionary _Nullable )success
                failure:(NJDHttpFailureBlock _Nonnull )fail;
@end
