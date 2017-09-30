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
+(NSError *)responseTypeError{
    NSError *err = [NSError errorWithDomain:@"response type error"
                                       code:1001
                                   userInfo:@{@"NSLocalizedDescription":@"response type error from server"}];
    return err;
}
+(AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = kTimeout;

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];

    return manager;
}

+(AFHTTPSessionManager *)loginWithUsername:(nonnull NSString *)username
                                  password:(NSString *)password
                                   success:(NJDHttpSuccessBlockDictionary)success
                                   failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *manager = [self manager];
   NSURLSessionTask *task = [manager GET:kURL(kUserDomain, kLoginPath)
                              parameters:@{@"username":SAFE_STRING(username),
                                     @"password":SAFE_STRING(password)
                                     }
                        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if([responseObject isKindOfClass:[NSDictionary class]]){
                               !success?:success(responseObject);
                            }else{
                                !fail?:fail([self responseTypeError]);
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            !fail?:fail(error);
                        }];
    
    [self printfUrl:task.currentRequest.URL];
    return manager;
}

+(AFHTTPSessionManager *)registerName:(NSString * _Nonnull)name
                                  pwd:(NSString * _Nonnull)pwd
                         identityCard:(NSString * _Nonnull)idcard
                      telephoneNumber:(NSString * _Nonnull)phone
                                 flag:(NSString * _Nonnull)flag
                                  sex:(NSInteger)sex
                               nation:(NSString *)nation
                           oldAddress:(NSString *)oldAddress
                      identityImgFile:(UIImage *)identityImg
                              success:(NJDHttpSuccessBlockDictionary)success
                              failure:(NJDHttpFailureBlock)faile{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager ]
    return nil;
}

@end
