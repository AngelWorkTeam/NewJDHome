//
//  FDOrPTYHVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/2.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "FDOrPTYHVC.h"
#import "SettingVC.h"
#import "SubmitVC.h"
#import "TermVC.h"

#import "RequestHistoryViewController.h"
#import "RenderUnRegisterRecordVC.h"

@interface FDOrPTYHVC ()
//房屋地址，只有当登入用户是房东时，才有此属性
@property (nonatomic,copy) NSArray *addresses;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *banner;
@end

@implementation FDOrPTYHVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNoBackWithOpaue:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privte metod
-(void)initViews{
    [self createNoBackWithOpaue:YES];
    self.title = @"新金东人之家";
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                             action:@selector(settingHandle:)];
    //根据类型初始化UI
    if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
        self.banner.image = [UIImage imageNamed:@"landPoster"];
        self.img1.image = [UIImage imageNamed:@"landSubmit"];
        self.img2.image = [UIImage imageNamed:@"landUnregister"];
        self.img3.image = [UIImage imageNamed:@"landAddress"];
        self.img4.image = [UIImage imageNamed:@"landRecord"];
    }else{
        self.banner.image = [UIImage imageNamed:@"renterPoster"];
        self.img1.image = [UIImage imageNamed:@"renterSubmit"];
        self.img2.image = [UIImage imageNamed:@"renterApply"];
        self.img3.image = [UIImage imageNamed:@"renterSubmitOther"];
        self.img4.image = [UIImage imageNamed:@"renterRecord"];
    }
}
-(void)initData{
    if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
        [NetworkingManager getLandLordAddressSuccess:^(NSArray * _Nullable arrayValue) {
            self.addresses = arrayValue;
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
}
-(UIViewController *)getVCFromSB:(NSString *)sbName identifier:(NSString *)id{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:id];
    return vc;
}
#pragma mark - action handle
-(void)settingHandle:(UIBarButtonItem *)item{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingVC *vc =[sb instantiateViewControllerWithIdentifier:@"settingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tapApplyView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.view.tag == 1000) {
            SubmitVC *vc = [SubmitVC new];
            vc.type = [NJDUserInfoMO roleType] == BNRRoleTypeLandlord?SubmitTypeRenter:SubmitTypeOwn;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(sender.view.tag == 1001){
            if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
                UIViewController *vc = [RenderUnRegisterRecordVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                TermVC *vc = [TermVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if(sender.view.tag == 1002){
            if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
                [self.navigationController pushViewController:[self getVCFromSB:@"Main" identifier:@"houseManagerVC"] animated:YES];
            }else{
                SubmitVC *vc = [SubmitVC new];
                vc.type = SubmitTypeOther;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(sender.view.tag == 1003){
            
            RequestHistoryViewController *vc = [RequestHistoryViewController new];
            [self.navigationController pushViewController:vc animated:YES];

            if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
                
            }else{
                
            }
        }
    }
}

@end
