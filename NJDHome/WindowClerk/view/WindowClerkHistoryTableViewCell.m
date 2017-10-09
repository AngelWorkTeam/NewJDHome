//
//  WindowClerkHistoryTableViewCell.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowClerkHistoryTableViewCell.h"

@interface WindowClerkHistoryTableViewCell ()
@property (nonatomic, strong) WindowclerkBaseView *contentUserInfo;
@end
@implementation WindowClerkHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (void)initContentView
{
    WindowclerkBaseView  *contentUserInfo = [[WindowclerkBaseView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:contentUserInfo];
    _contentUserInfo = contentUserInfo;
    @weakify(self)
    _contentUserInfo.windowAction = ^(NSInteger index, NSString *title){
        @strongify(self)
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(windowClerkHistoryButtonAction:withModel:)]) {
            [self.cellDelegate windowClerkHistoryButtonAction:index withModel:self.model];
        }
    };
    
    [contentUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    UIView *caozuoview = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:caozuoview];
    
    [caozuoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentUserInfo.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(2);
    }];
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@"备注:"];
    [caozuoview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caozuoview.mas_top);
        make.left.mas_equalTo(caozuoview.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_greaterThanOrEqualTo(windowclekcellHeight);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

- (UILabel *)createTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
    titleLable.font = [UIFont systemFontOfSize:12];
    return titleLable;
}

- (void)setModel:(WindowClerkCellModel *)model
{
    _model = model;
    
    _contentUserInfo.model = model;
    
}

@end
