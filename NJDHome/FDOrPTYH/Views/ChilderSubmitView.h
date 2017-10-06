//
//  ChilderSubmitView.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChilderSubmitView : UIView
@property (nonatomic,copy) void (^changeChildInfo)(NSDictionary *childInfo);
@property (nonatomic,copy) NSDictionary *childInfo;
@end
