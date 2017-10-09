//
//  WindowRejectReasonView.h
//  NJDHome
//
//  Created by yuan yunlong on 2017/10/9.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^windrejectReasonAction) (NSString *reason);
@interface WindowRejectReasonView : UIView

@property (nonatomic, copy) windrejectReasonAction windrejectReasonAction;
@end
