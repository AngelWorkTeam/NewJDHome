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
typedef void (^NJDHttpSuccessBlockId)(id response);
typedef void(^NJDHttpSuccessBlockString)(NSString *stringValue);
typedef void(^NJDHttpSuccessBlockNumber)(NSNumber *numberValue);
typedef void(^NJDHttpSuccessBlockDictionary)(NSDictionary *dictValue);
typedef void(^NJDHttpSuccessBlockArray)(NSArray *arrayValue);
typedef void(^NJDHttpSuccessBlockImage)(UIImage *image);
typedef void (^NJDHttpFailureBlock)(NSError *error);

@interface NetworkingManager : NSObject

+(AFHTTPSessionManager *)loginWithUsername:(NSString *)username
                                  password:(NSString *)password
                                   success:(NJDHttpSuccessBlockDictionary)success
                                   failure:(NJDHttpFailureBlock)fail
;

//+(AFHTTPSessionManager *)register
@end
