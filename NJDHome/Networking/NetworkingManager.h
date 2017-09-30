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

//+(AFHTTPSessionManager *)register
@end
