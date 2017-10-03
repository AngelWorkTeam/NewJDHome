//
//  AddressSelectView.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressSelectView : UIView
/**
 *detailArr字典中4个字典，每个字典是当前选择的地址的详细信息
 *address已经拼接好的地址
 */
@property (nonatomic,copy) void (^selectAddress)(NSArray *detailArr,NSString *address);
-(void)startShowAddr;
@end
