//
//  HETSleepActivityIndicatorView.h
//  HudDemo
//
//  Created by JustinYang on 2017/9/21.
//  Copyright © 2017年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HETSleepActivityIndicatorView : UIView
@property(nonatomic) BOOL                         hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO

/**
 *  设置颜色
 */
@property (nonatomic,copy) UIColor *activityTintColor;


- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)startAnimating;
- (void)stopAnimating;

@end
