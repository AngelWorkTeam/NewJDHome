//
//  TrafficAcceptView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAcceptView.h"

@interface TrafficAcceptView ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLbel;

@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UILabel *tempAddress;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UITextField *otherInfo;

@end

@implementation TrafficAcceptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initView
{
    
}
@end
