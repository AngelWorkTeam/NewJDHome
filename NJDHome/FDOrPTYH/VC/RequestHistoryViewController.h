//
//  RequestHistoryViewController.h
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYMessagesViewControllerProtocol <NSObject>

@required
- (NSArray<UIViewController *> *)yymessageChildViewControllerArray;

@end
@interface RequestHistoryViewController : NJDBaseController

@property (nonatomic, weak) id<YYMessagesViewControllerProtocol> childvcarrayDelegate;

@end
