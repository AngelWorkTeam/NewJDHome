//
//  NSString+HETAdditions.m
//  HETSDK
//
//  Created by JiangJun on 15/3/31.
//  Copyright (c) 2015年 JiangJun. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSData+SAMAdditions.h"
#import "NSString+Utils.h"

@implementation NSString (Utils)
- (NSString *)MD5AndBase64String {
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([[self dataUsingEncoding:NSUTF8StringEncoding] bytes], (CC_LONG)[self length], result);
    
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    
    NSString* base64String= [data sam_base64EncodedString];
    
    return base64String;
    
}


+(BOOL)isValidPassword:(NSString *)passwordStr
{
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passwordStr];
    return isMatch;
}
+ (BOOL)isValidStrongPassword:(NSString *)passwordStr{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passwordStr];
    return isMatch;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *newMobile = @"^((17[0-9])|(13[0-9])|(15[0-3,5-9])|(18[0-9])|(199)|(198)|(166)|(145)|(147))\\d{8}$";
    NSPredicate *regextesnewMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newMobile];
    return [regextesnewMobile evaluateWithObject:mobileNum];
}

//检查邮箱是否有效
+(BOOL)isValidEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

//检查时候包含emoji
+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

+ (NSString *)removeEmojiString:(NSString *)string{
    __block NSMutableString *str = [NSMutableString string];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (![NSString isContainsEmoji:substring]) {
            [str appendString:substring];
        }
    }];
    return [str copy];
}
+(BOOL) isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
@end
