//
//  SubmitCell5.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell5.h"
#import <Photos/Photos.h>
#import "imgsCell.h"
@interface SubmitCell5() <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation SubmitCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)takePhoto:(id)sender {
    BOOL canUse = YES;
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    canUse = !(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied);
#else
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    canUse = !(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied);
#endif
    if (!canUse) {
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
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([self isFrontCameraAvailable]) {
        controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:^{

    }];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (portraitImg.size.width > 960) {
            NSData *data = UIImageJPEGRepresentation(portraitImg, 0.2);
            portraitImg = [UIImage imageWithData:data scale:2];
        }
        
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:portraitImg];
//        imgView.frame = CGRectMake(0, 0, kScreenWidth*3, kScreenWidth*3*portraitImg.size.height/portraitImg.size.width);
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        UIGraphicsBeginImageContext(imgView.frame.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [imgView.layer renderInContext:context];
//        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        !self.tookPhoto?:self.tookPhoto(portraitImg);
        [self.collectionView reloadData];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 16.;
        layout.headerReferenceSize = CGSizeMake(16, 0);
        layout.footerReferenceSize = CGSizeMake(16, 0);
        layout.itemSize = CGSizeMake(60, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 96) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"imgsCell" bundle:nil] forCellWithReuseIdentifier:@"imgsCell"];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
-(void)setImgs:(NSMutableArray *)imgs{
    _imgs = imgs;
    if (imgs.count >0) {
        [self addSubview:self.collectionView];
    }else{
        if ([self.collectionView superview]) {
            [self.collectionView removeFromSuperview];
        }
    }
    [self.collectionView reloadData];
}
#pragma mark - collectview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgs.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    imgsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgsCell" forIndexPath:indexPath];
    UIImage *img = self.imgs[indexPath.row];
    cell.imgView.image = img;
    @weakify(self);
    cell.deletCell = ^{
         @strongify(self);
        [self.imgs removeObjectAtIndex:indexPath.row];
        if (self.imgs.count == 0) {
            !self.deleteAllImgs?:self.deleteAllImgs();
        }else{
            [self.collectionView reloadData];
        }
    };
    return cell;
}
@end
