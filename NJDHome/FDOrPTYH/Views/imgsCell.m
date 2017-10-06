//
//  imgsCell.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "imgsCell.h"
@interface imgsCell()


@end
@implementation imgsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    tap.numberOfTapsRequired = 2;
    [self.imgView addGestureRecognizer:tap];
    self.imgView.userInteractionEnabled = YES;
}
- (void)tapHandle:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        !self.deletCell?:self.deletCell();
    }
}

@end
