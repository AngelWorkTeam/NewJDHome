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
NSString * const kRegister = @"regist";


@implementation NetworkingManager
+(void)printfUrl:(NSURL *)url{
    NSLog(@"req:%@",url.absoluteString);
}
+(NSError *)responseTypeError{
    NSError *err = [NSError errorWithDomain:@"response type error"
                                       code:1001
                                   userInfo:@{NSLocalizedDescriptionKey:@"服务器返回了错误的数据"}];
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

+(void)registerWithParams:(NSDictionary *)params
                              success:(NJDHttpSuccessBlockDictionary)success
                              failure:(NJDHttpFailureBlock)fail{
    AFHTTPSessionManager *manager = [self manager];
    NSMutableDictionary *dic = params.mutableCopy;
    UIImage *img = params[@"identityImgFile"];
    [dic removeObjectForKey:@"identityImgFile"];
    void (^formDataBlock)(id formData) = ^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = UIImageJPEGRepresentation(img, 0.75);
        [formData appendPartWithFileData: data
                                    name: @"identityImgFile"
                                fileName: @"identityImgFile.png"
                                mimeType: @"image/png"];
    };
    [manager POST:kURL(kUserDomain, kRegister)
       parameters:dic.copy
constructingBodyWithBlock:img?formDataBlock:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
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


@end
