//
//  TrafficZhuanjiaoView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficAssistantTaskModel.h"
#import "UserInfo.h"
typedef void (^TraffiZhuanjiaoAction) (UserInfo *name);

@interface TrafficZhuanjiaoView : UIView

@property (nonatomic, strong) TrafficAssistantTaskModel *model;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSMutableArray *xgyArray;

@property (nonatomic, copy) TraffiZhuanjiaoAction  zhuanjiaoAction;

@end
