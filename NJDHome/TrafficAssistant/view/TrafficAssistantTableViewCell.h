//
//  TrafficAssistantTableViewCell.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfoView.h"
#import "TrafficAssistantTaskModel.h"

@protocol TrafficAssistantTableViewCellDelegate <NSObject>

- (void)trafficActionButtonAction:(NSInteger)index withModel:(TrafficAssistantTaskModel *)model;

@end

typedef void (^buttonAction) (NSInteger index, NSString *title);
@interface TrafficAssistantTableViewCell : UITableViewCell

@property (nonatomic, copy) buttonAction trafficAction;
@property (nonatomic, weak) id<TrafficAssistantTableViewCellDelegate> cellDelgate;
@property (nonatomic, strong) TrafficAssistantTaskModel *model;
@end
