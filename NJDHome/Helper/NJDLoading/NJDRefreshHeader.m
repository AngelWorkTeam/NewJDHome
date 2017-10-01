//
//  HETSleepRefreshHeader.m
//  MJRefreshExample
//
//  Created by JustinYang on 2017/9/22.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "NJDRefreshHeader.h"
#import "HETSleepActivityIndicatorView.h"
@interface NJDRefreshHeader ()

@property (weak, nonatomic) HETSleepActivityIndicatorView *loadingView;

@end

@implementation NJDRefreshHeader
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    //MJRefreshHeader
    NJDRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    
    cmp.automaticallyChangeAlpha = YES;
    cmp.lastUpdatedTimeLabel.hidden = YES;
    cmp.stateLabel.hidden = YES;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    NJDRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    
    cmp.automaticallyChangeAlpha = YES;
    cmp.lastUpdatedTimeLabel.hidden = YES;
    cmp.stateLabel.hidden = YES;
    return cmp;
}
- (UIImageView *)arrowView
{
    return nil;
}
- (HETSleepActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        HETSleepActivityIndicatorView *loadingView = [[HETSleepActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        loadingView.activityTintColor = self.activityTintColor?self.activityTintColor:[UIColor whiteColor];
        [self addSubview:_loadingView = loadingView];
        
        [loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return _loadingView;
}

@end
