//
//  HETForgetPasswordThreeController.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "HETForgetPasswordThreeController.h"
@interface HETForgetPasswordThreeController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *securityButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation HETForgetPasswordThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    [self createBackNavWithOpaque:YES];
    self.passwordTextfield.placeholder = @"请设置不小于6位数密码";
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5.;
    [self configViewModel];
    // Do any additional setup after loading the view.
}
-(void)configViewModel{
    [[RACObserve(self.viewModel, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    [RACObserve(self.viewModel, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
    }];
    RAC(self.viewModel,password) = self.passwordTextfield.rac_textSignal;
    
    @weakify(self);
    [[RACSignal merge:@[self.passwordTextfield.rac_textSignal,
                        RACObserve(self.passwordTextfield, text)]] subscribeNext:^(NSString  *x) {
        @strongify(self);
        if (x.length >= 6) {
            self.nextBtn.alpha = 1.;
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.alpha = 0.6;
            self.nextBtn.enabled = NO;
        }
    }];
}
- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
    @weakify(self);
    [[self.viewModel forgetPassword] subscribeCompleted:^{
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


- (IBAction)securityBtnClick:(id)sender {
    self.passwordTextfield.secureTextEntry = !self.passwordTextfield.secureTextEntry;
    [self.securityButton setImage:[UIImage imageNamed:self.passwordTextfield.secureTextEntry?@"passwordUnLook":@"passwordLook"] forState:UIControlStateNormal];
}

#pragma mark ---system method

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
