//
//  SubmitCell3.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell3.h"
@interface SubmitCell3()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end
@implementation SubmitCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(void)setContentStr:(NSString *)contentStr{
    self.contentTextField.text = contentStr;
}
-(NSString *)contentStr{
    return self.contentTextField.text;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    self.contentTextField.placeholder = placeHolder;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    !self.shouldLoacteMiddle?:self.shouldLoacteMiddle();
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    !self.didChangeValue?:self.didChangeValue(textField.text);
}
@end
