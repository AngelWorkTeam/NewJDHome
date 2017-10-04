//
//  BNRTapLabel.m
//  Smart
//
//  Created by IT_yangjing on 12/2/14.
//  Copyright (c) 2014 IT_yangjing. All rights reserved.
//

#import "BNRTapLabel.h"


@interface BNRTapLabel ()

@end
@implementation BNRTapLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)addTarget:(id)target action:(SEL)action {
    if (_tapGesture) {
        _tapGesture = nil;
    }
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    _tapGesture.enabled = YES;
    _tapGesture.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:_tapGesture];
}
@end
