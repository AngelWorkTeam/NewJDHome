//
//  SubmitCell.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitCell : UITableViewCell
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *contentStr;
@property (nonatomic,copy) NSString *placeHolder;

@property (nonatomic,copy) void (^shouldDismissKeyboard)(void);
@property (nonatomic,copy) void (^shouldLoacteMiddle)(void);

@property (nonatomic,copy) void (^didChangeValue)(id value);
@end
