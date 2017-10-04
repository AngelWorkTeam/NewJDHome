//
//  BNRTapLabel.h
//  Smart
//
//  Created by IT_yangjing on 12/2/14.
//  Copyright (c) 2014 IT_yangjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRTapLabel : UILabel
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;
- (void)addTarget:(id)target action:(SEL)action;
@end
