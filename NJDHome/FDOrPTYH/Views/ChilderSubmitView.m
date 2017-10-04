//
//  ChilderSubmitView.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ChilderSubmitView.h"
#import "BNRTapLabel.h"
#import "PickView1.h"
#import "DayPicker.h"
@interface ChilderSubmitView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BNRTapLabel *genderLabel;
@property (weak, nonatomic) IBOutlet BNRTapLabel *birthdayLabel;
@end
@implementation ChilderSubmitView
-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:self options:nil][6];
    if (self) {
        self.nameTextField.delegate = self;
        [self.genderLabel addTarget:self action:@selector(tapgenderHandle:)];
        [self.birthdayLabel addTarget:self action:@selector(tapBirthdayHandle:)];
        self.birthdayLabel.text = [[NSDate date] LocalDayISO8601String];
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *tmp = _childInfo.mutableCopy;
    tmp[@"childName"] = SAFE_STRING(textField.text);
    _childInfo = tmp.copy;
    !self.changeChildInfo?:self.changeChildInfo(self.childInfo);
}
-(void)tapgenderHandle:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.nameTextField resignFirstResponder];
        PickView1 *pickView1 = [PickView1 new];
        pickView1.selectData = ^(NSString *element, NSInteger index){
            self.genderLabel.text = element;
            NSMutableDictionary *tmp = self->_childInfo.mutableCopy;
            tmp[@"childSex"] = SAFE_STRING(element);
            self->_childInfo = tmp.copy;
            !self.changeChildInfo?:self.changeChildInfo(self.childInfo);
        };
        pickView1.dataArr = @[@"男",@"女"];
        [[UIApplication sharedApplication].keyWindow addSubview:pickView1];
        pickView1.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 218);
        
        [UIView animateWithDuration:0.4 animations:^{
            pickView1.frame = CGRectMake(0, kScreenHeight-218, kScreenWidth, 218);
        }];
    }
}
-(void)tapBirthdayHandle:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.nameTextField resignFirstResponder];
        DayPicker *dayView = [DayPicker new];
        @weakify(self);
        dayView.selectDay = ^(NSString *day) {
             @strongify(self);
            self.birthdayLabel.text = day;
            NSMutableDictionary *tmp = self->_childInfo.mutableCopy;
            tmp[@"childBirth"] = SAFE_STRING(day);
            self->_childInfo = tmp.copy;
            !self.changeChildInfo?:self.changeChildInfo(self.childInfo);
        };
        dayView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:dayView];
    }
}


-(void)setChildInfo:(NSDictionary *)childInfo{
    _childInfo = childInfo;
    self.nameTextField.text = SAFE_STRING(childInfo[@"childName"]);
    self.genderLabel.text = SAFE_STRING(childInfo[@"childSex"]);
    self.birthdayLabel.text = SAFE_STRING(childInfo[@"childBirth"]);
}
@end
