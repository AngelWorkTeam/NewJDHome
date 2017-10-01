//
//  MBProgressHUD+NJDProgressHUD.m
//  CSleepDolphin
//
//  Created by JustinYang on 2017/9/21.
//  Copyright © 2017年 HET. All rights reserved.
//

#import "MBProgressHUD+NJDProgressHUD.h"
#import "HETSleepActivityIndicatorView.h"
@implementation MBProgressHUD (NJDProgressHUD)

- (void)updateIndicators {
    
    UIView *indicator = (UIView *)[self valueForKey:@"indicator"];
    BOOL isActivityIndicator = [indicator isKindOfClass:[HETSleepActivityIndicatorView class]];
    BOOL isRoundIndicator = [indicator isKindOfClass:[MBRoundProgressView class]];
    
    MBProgressHUDMode mode = self.mode;
    if (mode == MBProgressHUDModeIndeterminate) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [indicator removeFromSuperview];
            indicator = [[HETSleepActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [(HETSleepActivityIndicatorView *)indicator startAnimating];
            [self.bezelView addSubview:indicator];
        }
    }
    else if (mode == MBProgressHUDModeDeterminateHorizontalBar) {
        // Update to bar determinate indicator
        [indicator removeFromSuperview];
        indicator = [[MBBarProgressView alloc] init];
        [self.bezelView addSubview:indicator];
    }
    else if (mode == MBProgressHUDModeDeterminate || mode == MBProgressHUDModeAnnularDeterminate) {
        if (!isRoundIndicator) {
            // Update to determinante indicator
            [indicator removeFromSuperview];
            indicator = [[MBRoundProgressView alloc] init];
            [self.bezelView addSubview:indicator];
        }
        if (mode == MBProgressHUDModeAnnularDeterminate) {
            [(MBRoundProgressView *)indicator setAnnular:YES];
        }
    }
    else if (mode == MBProgressHUDModeCustomView && self.customView != indicator) {
        // Update custom view indicator
        [indicator removeFromSuperview];
        indicator = self.customView;
        [self.bezelView addSubview:indicator];
    }
    else if (mode == MBProgressHUDModeText) {
        [indicator removeFromSuperview];
        indicator = nil;
    }
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self setValue:indicator forKey:@"indicator"];
    
    if ([indicator respondsToSelector:@selector(setProgress:)]) {
        [(id)indicator setValue:@(self.progress) forKey:@"progress"];
    }
    
    [indicator setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(updateViewsForColor:) withObject:self.contentColor];
#pragma clang diagnostic pop
    [self setNeedsUpdateConstraints];
}

-(void)setActivityColor:(UIColor *)activityColor{
    HETSleepActivityIndicatorView *indicator = (HETSleepActivityIndicatorView *)[self valueForKey:@"indicator"];
    BOOL isActivityIndicator = [indicator isKindOfClass:[HETSleepActivityIndicatorView class]];
    if (isActivityIndicator) {
        indicator.activityTintColor = activityColor;
    }
}

-(UIColor *)activityColor{
    HETSleepActivityIndicatorView *indicator = (HETSleepActivityIndicatorView *)[self valueForKey:@"indicator"];
    return indicator.backgroundColor;
}
@end
