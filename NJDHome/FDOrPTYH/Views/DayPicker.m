//
//  DayPicker.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "DayPicker.h"
@interface DayPicker()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
@implementation DayPicker
-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:self options:nil][4];
    if (self) {
        self.datePicker.maximumDate = [NSDate date];
    }
    return self;
}
- (IBAction)tapHandle:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        !self.selectDay?:self.selectDay([self.datePicker.date LocalDayISO8601String]);
    }
}


@end
