//
//  ApplyCardCell2.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/5.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ApplyCardCell2.h"
@interface ApplyCardCell2()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation ApplyCardCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.btn1.selected = YES;
}
- (IBAction)btn1Handle:(id)sender {
    self.btn1.selected = YES;
    self.btn2.selected = NO;
    !self.shuldShowTextView?:self.shuldShowTextView(NO);
}
- (IBAction)btn2Handle:(id)sender {
    self.btn1.selected = NO;
    self.btn2.selected = YES;
    !self.shuldShowTextView?:self.shuldShowTextView(YES);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length < 5 ) {
        textView.text = @"收件地址:";
    }
}
@end
