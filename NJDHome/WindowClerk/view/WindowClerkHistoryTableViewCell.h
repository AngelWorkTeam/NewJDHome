//
//  WindowClerkHistoryTableViewCell.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowClerkCellModel.h"
#import "WindowclerkBaseView.h"



@protocol WindowClerkHistoryTableViewCellDelegate <NSObject>

- (void)windowClerkHistoryButtonAction:(NSInteger)index withModel:(WindowClerkCellModel *)model;

@end
@interface WindowClerkHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) WindowClerkCellModel *model;

@property (nonatomic, weak) id<WindowClerkHistoryTableViewCellDelegate> cellDelegate;

@end
