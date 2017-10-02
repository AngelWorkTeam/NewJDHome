//
//  RegisterVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/1.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RegisterVC.h"
#import "IDCardVC.h"
@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UIButton *scanIdBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,copy) NSString *loadingMsg;
@property (nonatomic,copy) NSString *errorMsg;
@property (nonatomic,copy) UIImage *idImg;

@property (nonatomic,strong) NSMutableDictionary *registerDic;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackNavWithOpaque:YES];
    [self initViews];
    [self configViewModel];
}
-(void)viewWillAppear:(BOOL)animated{
    [self opaqueNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
-(void)initViews{
    self.title = [self.role isEqualToString:@"FD"]?@"房东注册":@"租客注册";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.scanIdBtn.layer.cornerRadius = 6.;
    self.scanIdBtn.layer.masksToBounds = YES;
    
}
-(void)configViewModel{
    self.registerDic = [NSMutableDictionary dictionary];
    @weakify(self);
   RACSignal *enableSignal = RAC(self.registerBtn,enabled) = [RACSignal
                                     combineLatest:@[self.nameTextFeild.rac_textSignal,
                                                     self.pwdTextField.rac_textSignal,
                                                     self.pwdAgainTextField.rac_textSignal,
                                                     self.idCardTextField.rac_textSignal,
                                                     self.phoneTextField.rac_textSignal]
                                     reduce:^id(NSString *name,NSString *pwd,
                                                NSString *pwdAgian, NSString *idCard,
                                                NSString *phone){
                                         return @((name.length>0&&pwd.length>0&&pwdAgian.length>0&&idCard.length>0&&phone.length>0));
                                     }];
    [enableSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.registerBtn.backgroundColor = [UIColor redColor];
        }else{
            self.registerBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
    
    [[RACObserve(self, loadingMsg) skip:1] subscribeNext:^(NSString *x) {
        x?[NJDPopLoading showMessageWithLoading:x]:[NJDPopLoading hideHud];
    }];
    
    [[RACObserve(self, errorMsg) skip:1] subscribeNext:^(id x) {
        if (x) {
            [NJDPopLoading showAutoHideWithMessage:x];
        }
    }];
}
-(void)idtifierIdWithImg:(UIImage *)img{
    self.loadingMsg = @"正在识别你的信息";
    [NetworkingManager identifierIdWithImg:img
                                   success:^(NSArray * _Nullable arrayValue) {
                                       self.loadingMsg = nil;
                                       NSDictionary *dic = [arrayValue firstObject];
                                       self.nameTextFeild.text = SAFE_STRING(dic[@"name"]);
                                       self.registerDic[@"sex"] = [SAFE_STRING(dic[@"gender"]) isEqualToString:@"女"]?@0:@1;
                                       self.registerDic[@"nation"] = SAFE_STRING(dic[@"race"]);
                                       self.idCardTextField.text = SAFE_STRING(dic[@"id_card_number"]);
                                       self.registerDic[@"oldAddress"] = SAFE_STRING(dic[@"address"]);
                                       self.registerDic[@"identityImgFile"] = img;
                                   } failure:^(NSError * _Nullable error) {
                                       self.errorMsg = error.userInfo[NSLocalizedDescriptionKey];
                                   }];
}
-(BOOL)inputValid{
    if (![self.pwdTextField.text isEqualToString:self.pwdAgainTextField.text]) {
        self.errorMsg = @"密码输入不一致";
        return NO;
    }
    if (self.pwdTextField.text.length < 6) {
        self.errorMsg = @"密码必须大于等于6位";
        return NO;
    }
    if (![NSString isValidateIdentityCard:self.idCardTextField.text]) {
        self.errorMsg = @"身份证输入有误";
        return NO;
    }
    if (![NSString isValidPassword:self.phoneTextField.text]) {
        self.errorMsg = @"手机号输入有误";
        return NO;
    }
    return YES;
}
#pragma mark - action handle

- (IBAction)registerHandle:(id)sender {
//    if([self inputValid] == NO){
//        return;
//    }
    self.registerDic[@"name"] = self.nameTextFeild.text;
    self.registerDic[@"pwd"] = self.pwdTextField.text;
    self.registerDic[@"identityCard"] = self.idCardTextField.text;
    self.registerDic[@"telephoneNumber"] = self.phoneTextField.text;
    self.registerDic[@"flag"] = [self.role isEqualToString:@"FD"]?@"FD":@"RY";
    
    [NetworkingManager registerWithParams:self.registerDic.copy
                                  success:^(NSDictionary * _Nullable dictValue) {
                                      
                                  } failure:^(NSError * _Nullable error) {
                                      
                                  }];
}
- (IBAction)pushToIDCardVC:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IDCardVC *vc = [sb instantiateViewControllerWithIdentifier:@"IDCardVC"];
    @weakify(self);
    vc.idCardImg = ^(UIImage *img){
         @strongify(self);
        [self idtifierIdWithImg:img];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setErrorMsg:(NSString *)errorMsg{
    self.loadingMsg = nil;
    _errorMsg = errorMsg;
}
@end
