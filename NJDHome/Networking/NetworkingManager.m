//
//  NetworkingManager.m
//  NJDHome
//
//  Created by JustinYang on 2017/9/29.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NetworkingManager.h"

#define kURL(domain,path) [[kBaseUrl stringByAppendingString:domain]\
                            stringByAppendingString:path]
const NSInteger kTimeout    = 30;

NSString * const kBaseUrl = @"http://218.75.95.243:8089/";

NSString * const kUserDomain = @"ldrk/client/";
NSString * const kLoginPath = @"login";


@implementation NetworkingManager
+(void)printfUrl:(NSURL *)url{
    NSLog(@"req:%@",url.absoluteString);
}

+(AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeout;

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];

    return manager;
}

+(AFHTTPSessionManager *)loginWithUsername:(NSString *)userName
                                  password:(NSString *)password{
    AFHTTPSessionManager *manager = [self manager];
   NSURLSessionTask *task = [manager GET:kURL(kUserDomain, kLoginPath)
                        parameters:@{@"username":SAFE_STRING(userName),
                                     @"password":SAFE_STRING(password)
                                     }
                        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                            
                        }];
    
    [self printfUrl:task.currentRequest.URL];
    return manager;
}


@end
