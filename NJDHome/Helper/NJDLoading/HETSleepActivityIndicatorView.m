//
//  HETSleepActivityIndicatorView.m
//  HudDemo
//
//  Created by JustinYang on 2017/9/21.
//  Copyright © 2017年 Matej Bukovinski. All rights reserved.
//

#import "HETSleepActivityIndicatorView.h"
#import <Masonry/Masonry.h>
@interface HETSleepActivityIndicatorView()

@end
@implementation HETSleepActivityIndicatorView

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    self = [super init];
    if (self) {
        UIImageView *mask = [UIImageView new];
        mask.image = style==UIActivityIndicatorViewStyleWhiteLarge?[UIImage imageNamed:@"activityBig"]:[UIImage imageNamed:@"activitySmall"];
        [mask sizeToFit];
        self.frame = mask.bounds;
        self.layer.mask = mask.layer;
        self.activityTintColor = [UIColor whiteColor];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(mask.image.size.height));
        }];
    }
    return self;
}

- (void)startAnimating{
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotation.duration = 1.;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.cumulative = true;
    rotation.removedOnCompletion = NO;
    rotation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotation forKey:nil];
}
- (void)stopAnimating{
    [self.layer removeAllAnimations];
    if (self.hidesWhenStopped) {
        if ([self superview]) {
            [self removeFromSuperview];
        }
    }
}
-(void)setActivityTintColor:(UIColor *)activityTintColor{
    self.backgroundColor = activityTintColor;
}

@end
