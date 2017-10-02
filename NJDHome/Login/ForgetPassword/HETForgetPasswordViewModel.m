//
//  HETForgetPasswordViewModel.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETForgetPasswordViewModel.h"
#import "NSString+Utils.h"
//#import "HETSDK.h" 
@interface HETForgetPasswordViewModel()
@property (copy,nonatomic)NSString *randomStr;
@end

@implementation HETForgetPasswordViewModel
-(instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

#pragma mark ----------------- STEP   1-------

-(RACSignal*)sendVerificationCode{
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendCompleted];
//        return nil;
//    }];
    if (![self isValidAccount]) {
        self.errorMsg = nil;
        return nil;
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.loadingMsg = @"请稍候...";
        @strongify(self);
        
        [NetworkingManager getCodeWithPhone:self.account
                                    success:^(NSDictionary * _Nullable dictValue) {
                                        @strongify(self);
                                        self.loadingMsg = nil;
                                        if([[dictValue valueForKeyPath:@"accessResult.success"] boolValue] == YES &&
                                           dictValue[@"code"]){
                                            self.verificationCodeFromServer = dictValue[@"code"];
                                            NSLog(@"xxxx %@",self.verificationCodeFromServer);
                                            [subscriber sendCompleted];
                                        }else{
                                            self.loadingMsg = nil;
                                            self.errorMsg = @"发送验证码出错";
                                            self.errorMsg = nil;
                                            [subscriber sendError:nil];
                                        }
                                        return;
                                    }
                                    failure:^(NSError * _Nullable error) {
                                        @strongify(self);
                                        self.loadingMsg = nil;
                                        self.errorMsg =error.userInfo[@"NSLocalizedDescription"];
                                        self.errorMsg = nil;
                                        [subscriber sendError:nil];
                                    }];
        return nil;
    }];
}
/**
 *  账号是否合法
 */
-(BOOL)isValidAccount{
    if (!self.account || [self.account isEqualToString:@""]) {
//        self.errorMsg = @"请输入账号";
        return NO;
    }
    if (![NSString isMobileNumber:self.account]) {
//        self.errorMsg = @"账号格式错误";
        return NO;
    }
    return YES;
}

#pragma mark ----------------- STEP   2-------
-(RACSignal*)verifyVerificationCode{
    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendCompleted];
//        return nil;
//    }];
    
    if (![self isValidVerificationCode]) {
        self.errorMsg = nil;
        return nil;
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([self.verificationCodeFromServer isEqualToString:self.verificationCode]) {
            [subscriber sendCompleted];
        }else{
            self.errorMsg = @"输入验证码错误";
            self.errorMsg = nil;
            [subscriber sendError:nil];
        }
        
        return nil;
    }];
}
/**
 *  验证码是否合法
 */
-(BOOL)isValidVerificationCode{
    if (!self.verificationCode || [self.verificationCode isEqualToString:@""]) {
        self.errorMsg = @"请输入验证码";
        return NO;
    }
    return YES;
}

#pragma mark ----------------- STEP   3-------
-(RACSignal*)forgetPassword{
    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [subscriber sendCompleted];
//        return nil;
//    }];
    
    
    if (![self isValidPassword]) {
        self.errorMsg = nil;
        return nil;
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.loadingMsg = @"请稍候...";
        
        [NetworkingManager changePasswordWithOld:nil
                                             new:self.account
                                           phone:self.account
                                         success:^(NSDictionary * _Nullable dictValue) {
                                             @strongify(self);
                                             self.loadingMsg = nil;
                                             self.errorMsg = @"密码重置成功";
                                             self.errorMsg = nil;
                                             [subscriber sendCompleted];
                                         }
                                         failure:^(NSError * _Nullable error) {
                                             @strongify(self);
                                             self.loadingMsg = nil;
                                             self.errorMsg =error.userInfo[@"NSLocalizedDescription"];
                                             self.errorMsg = nil;
                                             [subscriber sendError:nil];
                                         }];
        return nil;
    }];
}
/**
 *  密码是否合法
 */
-(BOOL)isValidPassword{
    if (!self.password || [self.password isEqualToString:@""]) {
        self.errorMsg = @"请输入密码";
        return NO;
    }
    if (self.password.length < 6) {
        self.errorMsg = @"密码长度不能小于6个字符";
        return NO;
    }
    return YES;
}

@end
