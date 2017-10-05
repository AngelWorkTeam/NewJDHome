//
//  GlobleMacro.h
//  NJDHome
//
//  Created by JustinYang on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#ifdef kScreenHeight
#undef kScreenHeight
    #define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

#ifdef kScreenWidth
#undef kScreenWidth
    #define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif


#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)

#define SAFE_STRING2(str) (![str isKindOfClass: [NSString class]] ? @"--" : str)

#define SAFE_NUMBER(value) (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)

#ifdef RACObserve
#undef RACObserve
#define RACObserve(TARGET, KEYPATH) \
({ \
__weak id target_ = (TARGET); \
[target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
})
#endif

extern NSString * const kFacePlusAPIKey;
extern NSString * const kFacePlusAPISecret;

//手动这个通知，就应该pop回登入界面了
extern NSString * const kTokenError;
