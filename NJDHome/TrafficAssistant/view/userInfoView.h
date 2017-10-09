//
//  userInfoView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrafficAssistantTaskModel.h"
@interface userInfoView : UIView


@property (nonatomic, strong) TrafficAssistantTaskModel *model;

@property (nonatomic, assign) BOOL needHidhenShenbaoLeixing;
@end
