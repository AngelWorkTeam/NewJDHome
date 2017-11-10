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
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
    self.scanIdBtn.layer.cornerRadius = 6.;
    self.scanIdBtn.layer.masksToBounds = YES;
    self.idCardTextField.placeholder = @"选填";
    
}
-(void)configViewModel{
    self.registerDic = [NSMutableDictionary dictionary];
    @weakify(self);
   RACSignal *enableSignal = RAC(self.registerBtn,enabled) = [RACSignal
                                     combineLatest:@[
                                                     [RACSignal
                                                      merge:@[self.nameTextFeild.rac_textSignal,
                                                             RACObserve(self.nameTextFeild, text)]],
                                                     self.pwdTextField.rac_textSignal,
                                                     self.pwdAgainTextField.rac_textSignal,
                                                 
                                                     self.phoneTextField.rac_textSignal]
                                     reduce:^id(NSString *name,NSString *pwd,
                                                NSString *pwdAgian,
                                                NSString *phone){
                                         return @((name.length>0&&pwd.length>0&&pwdAgian.length>0&&phone.length>0));
                                     }];
    [enableSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.registerBtn.backgroundColor = [UIColor redColor];
        }else{
            self.registerBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
    
    [[RACObserve(self, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    
    [RACObserve(self, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
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
    if (self.idCardTextField.text.length > 0) {
        if (![NSString isValidateIdentityCard:self.idCardTextField.text]) {
            self.errorMsg = @"身份证输入有误";
            return NO;
        }
    }
    if (![NSString isValidPassword:self.phoneTextField.text]) {
        self.errorMsg = @"手机号输入有误";
        return NO;
    }
    return YES;
}
#pragma mark - action handle

- (IBAction)registerHandle:(id)sender {
    if([self inputValid] == NO){
        return;
    }
    self.registerDic[@"name"] = self.nameTextFeild.text;
    self.registerDic[@"pwd"] = self.pwdTextField.text;
    if (self.idCardTextField.text.length > 0) {
        self.registerDic[@"identityCard"] = self.idCardTextField.text;
    }
    self.registerDic[@"telephoneNumber"] = self.phoneTextField.text;
    self.registerDic[@"flag"] = [self.role isEqualToString:@"FD"]?@"FD":@"RY";
    self.loadingMsg = @"正在注册";
    [NetworkingManager registerWithParams:self.registerDic.copy
                                  success:^(NSDictionary * _Nullable dictValue) {
                                      self.errorMsg = [dictValue valueForKeyPath:@"accessResult.resultMsg"];
                                      if ([[dictValue valueForKeyPath:@"result.success"] boolValue] == YES) {
                                          //同时也登入成功了
                                          [NJDUserInfoMO deleteAll];
                                          NJDUserInfoMO *info = [NJDUserInfoMO MR_createEntity];
                                          info.isLogin = YES;
                                          info.token = [dictValue valueForKeyPath:@"appLoginedInfo.token"];
                                          info.userId = [dictValue valueForKeyPath:@"appLoginedInfo.userId"];
                                          info.username = [dictValue valueForKeyPath:@"appLoginedInfo.user.username"];
                                          info.realName = [dictValue valueForKeyPath:@"appLoginedInfo.user.realName"];
                                          info.isdeleted = [[dictValue valueForKeyPath:@"appLoginedInfo.user.isDeleted"] intValue];
                                          info.isLocked = [[dictValue valueForKeyPath:@"appLoginedInfo.user.isLocked"] intValue];
                                          info.id = [dictValue valueForKeyPath:@"appLoginedInfo.user.id"];
                                          
                                          NSDictionary *role = [dictValue valueForKeyPath:@"appLoginedInfo.user.role"];
                                          if (role) {
                                              info.role = [NJDRoleInfoMO MR_createEntity];
                                              info.role.id = role[@"id"];
                                              info.role.isSystem = [role[@"isSystem"] boolValue];
                                              info.role.name = role[@"name"];
                                              info.role.no = role[@"no"];
                                          }else{
                                              info.isLogin = NO;
                                          }
                                          [NJDUserInfoMO save];
                                          UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                          UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FDOrPTYHVC"];
                                          NSArray *vcs = @[self.navigationController.viewControllers[0],vc];
                                          [self.navigationController setViewControllers:vcs animated:YES];
                                      }else if([[dictValue valueForKeyPath:@"result.success"] boolValue] == YES){ //只是注册成功
                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                          
                                      }
                                  } failure:^(NSError * _Nullable error) {
                                      self.errorMsg = error.userInfo[NSLocalizedDescriptionKey];
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
