//
//  SubmitCell4.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell4.h"

@implementation SubmitCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addChildInfo:(id)sender {
    !self.addChildInfo?:self.addChildInfo();
}
- (IBAction)minsChildInfo:(id)sender {
    !self.minsChildInfo?:self.minsChildInfo();
}

@end
