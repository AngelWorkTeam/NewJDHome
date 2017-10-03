//
//  HETForgetPasswordTwoController.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETForgetPasswordTwoController.h"
#import "HETForgetPasswordThreeController.h"

@interface HETForgetPasswordTwoController (){
    NSInteger _countdown;//倒计时
}
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
@property (weak, nonatomic) IBOutlet UILabel *resendLabel;
@property (strong,nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation HETForgetPasswordTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写验证码";
    [self createBackNavWithOpaque:YES];
    self.verificationCodeTextfield.placeholder = @"请输入验证码";
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5.;
    self.forgetPasswordTipLabel.text = [NSString stringWithFormat:@"%@(%@)",@"验证码已发送至您的手机",self.viewModel.account];
    _countdown =120;

    [self configViewModel];
    // Do any additional setup after loading the view.
}
-(void)configViewModel{
    
    [[RACObserve(self.viewModel, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage: errorMsg];
    }];
    
    [RACObserve(self.viewModel, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
    }];
    RAC(self.viewModel,verificationCode) = self.verificationCodeTextfield.rac_textSignal;
    @weakify(self);
    [[RACSignal merge:@[self.verificationCodeTextfield.rac_textSignal,
                        RACObserve(self.verificationCodeTextfield, text)]] subscribeNext:^(NSString  *x) {
        @strongify(self);
        if (x.length == 6) {
            self.nextBtn.alpha = 1.;
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.alpha = 0.6;
            self.nextBtn.enabled = NO;
        }
    }];
}

-(void)changeResendBtnStatus{
    _countdown--;
    if (_countdown == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.resendBtn.enabled = YES;
        self.resendLabel.text = @"重新发送";
        _countdown = 120;
        return;
    }
    self.resendBtn.enabled = NO;
    self.resendLabel.text = [NSString stringWithFormat:@"%@%@",@(_countdown),@"秒"];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(changeResendBtnStatus) userInfo:nil repeats:YES];
    }
}
- (IBAction)resentBtnClick:(id)sender {
    RACSignal *signal = [[self.viewModel sendVerificationCode] replay];
    /**
     *  重发验证码成功
     */
    @weakify(self);
    [signal subscribeCompleted:^{
        @strongify(self);
        [self changeResendBtnStatus];
    }];
}
- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
    @weakify(self);
    [[self.viewModel verifyVerificationCode] subscribeCompleted:^{
        @strongify(self);
        HETForgetPasswordThreeController *con = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HETForgetPasswordThreeController"];
        con.viewModel = self.viewModel;
        [self.navigationController pushViewController:con animated:YES];
    }];
}

#pragma mark ---system method

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeResendBtnStatus];
}
-(void)dealloc{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

