//
//  ModifyPswVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ModifyPswVC.h"

@interface ModifyPswVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@end

@implementation ModifyPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self createNoBackWithOpaue:YES];
    self.view.backgroundColor = [UIColor grayColor];
    self.userNameTextFeild.placeholder = [NJDUserInfoMO userInfo].username;
    self.userNameTextFeild.enabled = NO;
    
    @weakify(self);
    RACSignal *enableSignal =
    RAC(self.comfirmBtn,enabled) =
    [RACSignal combineLatest:
     @[self.oldPwdTextFeild.rac_textSignal,
       self.pwdNewTextField.rac_textSignal,
       self.pwdNewAgainTextField.rac_textSignal]
       reduce:^id(NSString *oldPwd,
                  NSString *pwd,
                  NSString *pwdAgian){
                   return @((oldPwd.length>0&&pwd.length>0&&pwdAgian.length));
                                                               }];
    [enableSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.comfirmBtn.backgroundColor = [UIColor redColor];
        }else{
            self.comfirmBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNoBackWithOpaue:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)comfirmHandle:(id)sender {
    
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
