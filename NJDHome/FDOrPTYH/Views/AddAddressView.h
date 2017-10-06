//
//  AddAddressView.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressView : UIView
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic,copy) void (^selectAddr)(NSString *id, NSString *addr);
-(void)showAt:(UIView *)view;
@end
