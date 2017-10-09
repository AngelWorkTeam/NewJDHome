//
//  WindowClerkTableViewCell.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowClerkCellModel.h"
@protocol WindowClerkTableViewCellDelegate <NSObject>

- (void)windowClerkButtonAction:(NSInteger)index withModel:(WindowClerkCellModel *)model;

@optional
- (void)windowClerkOperationAction:(NSInteger)index withModel:(WindowClerkCellModel *)model;

@end
@interface WindowClerkTableViewCell : UITableViewCell

@property (nonatomic, strong) WindowClerkCellModel *model;

@property (nonatomic, weak) id<WindowClerkTableViewCellDelegate> cellDelegate;

@end
