//
//  IDCardVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/1.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "IDCardVC.h"
#import <AVFoundation/AVFoundation.h>

@interface IDCardVC ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic)UIButton *PhotoButton;
@property (nonatomic)UIButton *flashButton;
@property (nonatomic)UIImageView *imageView;
@property (nonatomic)UIView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;
@end

@implementation IDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self cameraAuth]) {
        [self initViews];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self transparentNavigationBar];
}
-(void)initViews{
    [self createBackNavWithOpaque:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"闪关灯" style:UIBarButtonItemStylePlain target:self action:@selector(flashHandle:)];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    return ;
   
//    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(kScreenWidth*1/2.0-30, kScreenHeight-100, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(kScreenWidth*1/4.0-30, kScreenHeight-100, 60, 60);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth*3/4.0-60, kScreenHeight-100, 60, 60);
    [rightButton setTitle:@"切换" forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(kScreenWidth-80, kScreenHeight-100, 80, 60);
    [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashButton];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
-(void)flashHandle:(UIBarButtonItem *)item{
    
}
-(void)focusGesture:(UITapGestureRecognizer *)tap{
    
}
- (BOOL)cameraAuth{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
//        [NJDPopLoading showAutoHideWithMessage:@"请在'设置-隐私-相机'中打开权限"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"隐私设置" message:@"请在'设置-隐私-相机'中打开权限" preferredStyle:UIAlertControllerStyleAlert];
        @weakify(self);
        @weakify(alert);
        [alert addAction:
         [UIAlertAction actionWithTitle:@"确定"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
                                    @strongify(self);
                                    @strongify(alert);
                                    [alert
                                     dismissViewControllerAnimated:NO
                                     
                                                      completion:^{
//                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                          NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                          
                                                          if([[UIApplication sharedApplication] canOpenURL:url]) {
                                                              
                                                              [[UIApplication sharedApplication] openURL:url];
                                                              
                                                          }
                                              }];
                                   
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    else{
        return YES;
    }
}
@end
