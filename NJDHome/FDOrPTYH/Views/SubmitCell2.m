//
//  SubmitCell2.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell2.h"
#import "BNRTapLabel.h"
#import "PickView1.h"
#import "AddAddressView.h"
#import "DayPicker.h"
@interface SubmitCell2()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet BNRTapLabel *contentLabel;

@end
@implementation SubmitCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentLabel addTarget:self action:@selector(tapLableHandle:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)tapLableHandle:(UITapGestureRecognizer *)tap{
    if(tap.state == UIGestureRecognizerStateEnded){
        !self.shouldDismissKeyboard?:self.shouldDismissKeyboard();
        if (self.pickType == PickTypeCustom) {
            PickView1 *pickView1 = [PickView1 new];
            pickView1.selectData = ^(NSString *element, NSInteger index){
                self.contentStr = element;
                !self.didChangeValue?:self.didChangeValue(element);
            };
            pickView1.dataArr = self.dataSource;
            [[UIApplication sharedApplication].keyWindow addSubview:pickView1];
            pickView1.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 218);
            
            [UIView animateWithDuration:0.4 animations:^{
                pickView1.frame = CGRectMake(0, kScreenHeight-218, kScreenWidth, 218);
            }];
        }else if(self.pickType == PickTypeDate){
            DayPicker *dayView = [DayPicker new];
            dayView.selectDay = ^(NSString *day) {
                self.contentStr = day;
                !self.didChangeValue?:self.didChangeValue(day);
            };
            dayView.frame = [UIApplication sharedApplication].keyWindow.bounds;
            [[UIApplication sharedApplication].keyWindow addSubview:dayView];
        }else if(self.pickType == PickTypeAddr){
            AddAddressView *add = [AddAddressView new];
            [add showAt:[UIApplication sharedApplication].keyWindow];
            add.selectAddr = ^(NSString *regionId, NSString *address){
                self.contentStr = address;
                !self.didChangeValue?:self.didChangeValue(address);
            };
        }
    }
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(void)setContentStr:(NSString *)contentStr{
    self.contentLabel.text = contentStr;
}
-(NSString *)contentStr{
    return self.contentLabel.text;
}
@end
