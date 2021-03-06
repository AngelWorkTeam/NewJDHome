//
//  WindowclerkBaseView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowClerkCellModel.h"
typedef void (^windowbuttonAction) (NSInteger index, NSString *title);

@interface WindowclerkBaseView : UIView

@property (nonatomic, strong) WindowClerkCellModel *model;

@property (nonatomic, strong) windowbuttonAction windowAction;

@property (nonatomic, assign) BOOL hiddenIDCardImageButton;

@end
