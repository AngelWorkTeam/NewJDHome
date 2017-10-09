//
//  PickView1.h
//  CSleepNew
//
//  Created by JustinYang on 16/8/24.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickView1 : UIView
//开放出来，让可以设置颜色和透明度
@property (nonatomic,strong) UIView        *maskView;

//pickView的分割线颜色
@property (nonatomic,strong) UIColor       *pickViewLineColor;

@property (nonatomic,strong) UIColor       *cancelColor;

@property (nonatomic,strong) UIColor       *comfirmColor;
//确定 取消的分割线颜色
@property (nonatomic,strong) UIColor       *comfirmLineColor;

//pickView的元素字体颜色
@property (nonatomic,strong) UIColor       *pickItemColor;

//pickview字体大小
@property (nonatomic)       CGFloat        pickFontSize;

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,copy) void (^selectData)(id element,NSInteger index );

@property (nonatomic,copy) NSString *currentValue;
@property (nonatomic) NSInteger currentIndex;
@end
