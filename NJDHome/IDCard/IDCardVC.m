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

@property (nonatomic)UIView *focusView;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@end

@implementation IDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self cameraAuth]) {
        [self initCamera];
        [self initViews];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self transparentNavigationBar];
}
-(void)initViews{
    [self createBackNavWithOpaque:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"闪关灯" style:UIBarButtonItemStylePlain target:self action:@selector(flashHandle:)];
    
    [self showPreview:NO];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action handle
-(void)flashHandle:(UIBarButtonItem *)item{
    if (![self.device hasFlash]) {
        return;
    }
    if ([self.device lockForConfiguration:nil]) {
        if (self.device.flashMode == AVCaptureFlashModeOn) {
            if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.device setFlashMode:AVCaptureFlashModeOff];
                self.device.torchMode = AVCaptureTorchModeOff;
            }
        }else if(self.device.flashMode == AVCaptureFlashModeOff){
            if ([self.device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [self.device setFlashMode:AVCaptureFlashModeOn];
                self.device.torchMode = AVCaptureTorchModeOn;
            }
        }
        
        [self.device unlockForConfiguration];
    }
}
-(void)focusGesture:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tap locationInView:tap.view];
        [self focusAtPoint:point];
    }
}
- (IBAction)takePhotot:(id)sender{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    @weakify(self);
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         @strongify(self);
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        [self showPreview:YES];
        self.previewImgView.image = self.image;
    }];
}
- (IBAction)cancelHandle:(id)sender {
    [self.session startRunning];
    [self showPreview:NO];
    self.previewImgView.image = nil;
    self.image = nil;
}
- (IBAction)comfirmHandle:(id)sender {
    !self.idCardImg?:self.idCardImg(self.image);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (BOOL)cameraAuth{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"隐私设置" message:@"请在'设置-隐私-相机'中打开权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"确定"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
                                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                    
                                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                   
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    else{
        return YES;
    }
}

-(void)initCamera{
    self.view.backgroundColor = [UIColor lightGrayColor];
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
   
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.cameraView.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        if ([_device hasFlash]) {
            _device.flashMode = AVCaptureFlashModeOff;
            _device.torchMode = AVCaptureTorchModeOff;
        }
        [_device unlockForConfiguration];
    }
}

-(void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}

-(void)showPreview:(BOOL)show{
    self.previewImgView.hidden = !show;
    self.cancelBtn.hidden = !show;
    self.comfirmBtn.hidden = !show;
}
@end
