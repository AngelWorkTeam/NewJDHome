//
//  TrafficAcceptView.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrafficAssistantTaskModel.h"

typedef void (^TraffiAction) (NSString *checkDate,NSString *checkTime, NSString *userSuggest);

@interface TrafficAcceptView : UIView


@property (nonatomic, strong) TrafficAssistantTaskModel *model;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) TraffiAction TraffiAcceptAction;
@end
