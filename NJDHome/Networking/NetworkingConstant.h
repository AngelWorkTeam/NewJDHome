//
//  NetworkingConstant.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingConstant : NSObject

#define kURL(domain,path) [[kBaseUrl stringByAppendingString:domain]\
stringByAppendingString:path]



extern NSString * const kBaseUrl ;

extern NSString * const kUserDomain ;

extern const NSInteger kTimeout  ;

@end
