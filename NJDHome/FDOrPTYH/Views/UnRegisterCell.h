//
//  UnRegisterCell.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/10.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnRegisterCell : UITableViewCell
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *detailAddr;
@property (nonatomic,copy) NSString *roomNum;
@property (nonatomic,copy) void (^changeBlock)(void);
@property (nonatomic,copy) void (^unRegisterBlock)(void);
@end
