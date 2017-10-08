//
//  TrafficAcceptView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrafficAssistantTaskModel.h"

typedef void (^TraffiRejectAction) (NSString *timeStr, NSString *userSuggest);

@interface TrafficRejectView : UIView


@property (nonatomic, strong) TrafficAssistantTaskModel *model;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) TraffiRejectAction TraffiAcceptAction;

@property (nonatomic, strong) NSMutableArray *rejectReasonArray;
@end
