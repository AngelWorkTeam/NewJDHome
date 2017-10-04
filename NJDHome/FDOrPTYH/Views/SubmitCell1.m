//
//  submitCell1.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell1.h"
@interface SubmitCell1()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextFiel;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@end
@implementation SubmitCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scanBtn.layer.cornerRadius = 3.;
    self.scanBtn.layer.masksToBounds = YES;
    self.contentTextFiel.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
- (IBAction)scanHandle:(id)sender {
    !self.shouldDismissKeyboard?:self.shouldDismissKeyboard();
    !self.pushToTakeIdCard?:self.pushToTakeIdCard();
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(void)setContentStr:(NSString *)contentStr{
    self.contentTextFiel.text = contentStr;
}
-(NSString *)contentStr{
    return self.contentTextFiel.text;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    self.contentTextFiel.placeholder = placeHolder;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    !self.didChangeValue?:self.didChangeValue(textField.text);
}
@end
