//
//  GlobleMacro.h
//  NJDHome
//
//  Created by JustinYang on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)

#define SAFE_STRING2(str) (![str isKindOfClass: [NSString class]] ? @"--" : str)

#define SAFE_NUMBER(value) (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)


extern NSString * const kFacePlusAPIKey;
extern NSString * const kFacePlusAPISecret;

//手动这个通知，就应该pop回登入界面了
extern NSString * const kTokenError;





#define njdScreenHeight [UIScreen mainScreen].bounds.size.height
#define njdScreenWidth [UIScreen mainScreen].bounds.size.width
#define userinfocellHeight  20
