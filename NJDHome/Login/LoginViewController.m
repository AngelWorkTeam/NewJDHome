//
//  LoginViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userAccountTextfeild;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextfeild;
@property (weak, nonatomic) IBOutlet UIView *accountBackView;
@property (weak, nonatomic) IBOutlet UIButton *remberPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userPasswordTextfeild.placeholder = @"密码";
    [self.userPasswordTextfeild setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.userPasswordTextfeild setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    self.userAccountTextfeild.placeholder = @"邮箱或手机号";
    [self.userAccountTextfeild setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.userAccountTextfeild setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
//    self.remberPassword.titleLabel.font = [UIFont systemFontOfSize:11];
//    [self.remberPassword setTitle:@"记住密码" forState:UIControlStateNormal];
//    [self.remberPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.remberPassword setImage:[UIImage imageNamed:@"loginRemberPassword"] forState:UIControlStateNormal];
//    
//    CGRect imageRect = self.remberPassword.imageView.frame;
//    CGRect titleRect = self.remberPassword.titleLabel.frame;
//    
//    self.remberPassword.imageEdgeInsets = UIEdgeInsetsMake(0, titleRect.size.width + 10, 0,-titleRect.size.width);
//    self.remberPassword.titleEdgeInsets = UIEdgeInsetsMake(0, -imageRect.size.width, 0, imageRect.size.width);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(id)sender {
    
    [[AppDelegate sharedApplicationDelegate]loginSuccessWithUserType:Role_TrafficAssistant];
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
