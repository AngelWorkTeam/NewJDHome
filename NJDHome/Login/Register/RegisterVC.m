//
//  RegisterVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/1.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RegisterVC.h"

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.scanIdBtn.layer.cornerRadius = 6.;
    self.scanIdBtn.layer.masksToBounds = YES;
    
}
-(void)configViewModel{
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
                                         return @((pwd.length>0&&pwd.length>0&&pwdAgian.length>0&&idCard.length>0&&phone.length>0));
                                     }];
    [enableSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.registerBtn.backgroundColor = [UIColor redColor];
        }else{
            self.registerBtn.backgroundColor = [UIColor colorFromHexRGB:@"ff0000" alpha:0.5];
        }
    }];
    
}
#pragma mark - action handle

- (IBAction)registerHandle:(id)sender {
}
@end
