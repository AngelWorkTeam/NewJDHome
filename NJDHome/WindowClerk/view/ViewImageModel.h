//
//  ViewImageModel.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/10/9.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewImageModel : NSObject

// 1 身份证照片
// 0 流动人口照片
- (instancetype)initWithPhotoArray:(NSArray *)array recordId:(NSString *)recordId type:(NSString *)type;

- (void)showImageBrowserWithNav:(UINavigationController *)nav;

@end
