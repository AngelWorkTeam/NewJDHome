//
//  NetworkingManager.h
//  NJDHome
//
//  Created by JustinYang on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface NetworkingManager : NSObject

+(AFHTTPSessionManager *)loginWithUsername:(NSString *)username
                                  password:(NSString *)password
;

@end
