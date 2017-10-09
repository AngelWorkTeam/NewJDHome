//
//  ViewImageModel.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/10/9.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ViewImageModel.h"
#import "MWPhotoBrowser.h"
#import "NetworkingConstant.h"
@interface ViewImageModel() <MWPhotoBrowserDelegate>
@property (nonatomic, strong)    MWPhotoBrowser *browser;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *photoType;  //1是查看身份证照片 0流动人口照片
@property (nonatomic, strong) NSArray *array;
@end

@implementation ViewImageModel

- (instancetype)initWithPhotoArray:(NSArray *)array recordId:(NSString *)recordId type:(NSString *)type
{
    self = [super init];
    if (self) {
        _array = array;
        _recordId = recordId;
        _photoType = type;
        [self initBrowser];
    }
    return self;
}

- (void)initBrowser
{

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //设置当前要显示的图片
    [browser setCurrentPhotoIndex:1];
    _browser  = browser;
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _array.count;
    
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    NSString *str =[_array objectAtIndex:index];
    NSString *pathStr = kURL(kBaseUrl,str);
    NSString *token = SAFE_STRING([NJDUserInfoMO userInfo].token);
    NSString *requestStr = [NSString stringWithFormat:@"%@&token=%@&recordId=%@&pictureType=0",pathStr,token,_recordId];
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:requestStr]];

    return photo;
}

- (void)showImageBrowserWithNav:(UINavigationController *)nav
{
    [nav pushViewController:_browser animated:true];
}
@end
