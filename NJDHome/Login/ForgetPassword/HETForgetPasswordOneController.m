//
//  HETForgetPasswordOneController.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETForgetPasswordOneController.h"
#import "HETForgetPasswordViewModel.h"
#import "HETForgetPasswordTwoController.h"
//#import "HETLoginCustomConfig+Private.h"
//#import "HETPublicButton.h"
@interface HETForgetPasswordOneController ()
@property (weak, nonatomic) IBOutlet UILabel *beforeAccountLabel;//输入框前的文字
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;//忘记手机号码或者邮箱输入框


@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong,nonatomic)HETForgetPasswordViewModel *viewModel;
@end

@implementation HETForgetPasswordOneController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self createBackNavWithOpaque:YES];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5.;
    [self configViewModel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createBackNavWithOpaque:YES];
}
-(void)configViewModel{
    self.viewModel = [HETForgetPasswordViewModel new];
    @weakify(self);
    [[RACObserve(self.viewModel, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    
    [RACObserve(self.viewModel, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
    }];
    
    
    [[RACSignal merge:@[self.accountTextField.rac_textSignal,
                        RACObserve(self.accountTextField, text)]] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.account = self.accountTextField.text;
        self.nextBtn.enabled = [self.viewModel isValidAccount];
        if (self.nextBtn.enabled) {
            self.nextBtn.alpha = 1.;
        }else{
            self.nextBtn.alpha = 0.6;
        }
    }];
}


#pragma mark --button click

- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    RACSignal *signal = [[self.viewModel sendVerificationCode] replay];
    @weakify(self);
    /**
     *  发送验证码成功
     */
    [signal subscribeCompleted:^{
        @strongify(self);
        HETForgetPasswordTwoController *con = (HETForgetPasswordTwoController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HETForgetPasswordTwoController"];
        con.viewModel = self.viewModel;
        [self.navigationController pushViewController:con animated:YES];
    }];
    /**
     *  已经注册
     */
    [signal subscribeError:^(NSError *error) {
        NSLog(@"已经注册");
    }];
    
}


#pragma mark ---system method

-(void)dealloc{
    
}


@end
