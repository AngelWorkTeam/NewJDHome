//
//  TrafficAcceptView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrafficAssistantTaskModel.h"

typedef void (^TraffiRejectAction) (NSString *reason, NSString *userSuggest);

@interface TrafficRejectView : UIView

@property (nonatomic, strong) UILabel *tuihuiyuanyinTitle ;  //退回原因title
@property (nonatomic, strong) UILabel *qitayuanyinTitle;     //其他原因title
@property (nonatomic, strong)  UIButton *acceptButton ;     // 确认button

@property (nonatomic, strong) TrafficAssistantTaskModel *model;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) TraffiRejectAction TrafficRejectAction;

@property (nonatomic, strong) NSMutableArray *rejectReasonArray;
@end
