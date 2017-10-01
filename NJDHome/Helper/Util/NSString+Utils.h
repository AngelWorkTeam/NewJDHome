//
//  NSString+HETAdditions.h
//  HETSDK
//
//  Created by JiangJun on 15/3/31.
//  Copyright (c) 2015年 JiangJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
- (NSString *)MD5AndBase64String;


+ (BOOL)isMobileNumber:(NSString *)mobileNum;//手机号验证


+(BOOL)isValidEmail:(NSString *)emailStr;//检查邮箱是否有效

+ (BOOL)isValidPassword:(NSString *)passwordStr;//检查密码格式是否正确
+ (BOOL)isValidStrongPassword:(NSString *)passwordStr;//加强版密码格式校验

+ (BOOL)isContainsEmoji:(NSString *)string;//检查时候包含emoji

+ (NSString *)removeEmojiString:(NSString *)string;//去除emoji
+ (BOOL) isValidateIdentityCard: (NSString *)identityCard;
@end
