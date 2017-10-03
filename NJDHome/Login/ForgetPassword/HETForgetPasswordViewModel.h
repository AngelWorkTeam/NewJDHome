//
//  HETForgetPasswordViewModel.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETForgetPasswordViewModel : NSObject
/**
 *  账户
 */
@property (copy,nonatomic)NSString *account;

/**
 *  密码
 */
@property (copy,nonatomic)NSString *password;
/**
 *  验证码
 */
@property (copy,nonatomic)NSString *verificationCode;

/**
 *  服务器返回的验证码
 */
@property (copy,nonatomic)NSString *verificationCodeFromServer;

/**
 *  出错信息
 */
@property (nonatomic,copy)NSString *errorMsg;
/**
 * loading中显示文字
 */
@property (nonatomic,copy)NSString *loadingMsg;


/**
 *  发送验证码
 *
 *  @return completed:发送成功   error:已经注册
 */
-(RACSignal*)sendVerificationCode;

/**
 *  验证验证码
 *
 *  @return completed:验证成功
 */
-(RACSignal*)verifyVerificationCode;

/**
 *  忘记密码
 *  @return completed:忘记成功
 */
-(RACSignal*)forgetPassword;

/**
 *  账号是否合法
 */
-(BOOL)isValidAccount;
@end
