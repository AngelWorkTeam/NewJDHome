//
//  WindowClerkTableViewCell.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowClerkTableViewCell.h"
#import "WindowclerkBaseView.h"
@interface WindowClerkTableViewCell ()
@property (nonatomic, strong) WindowclerkBaseView *contentUserInfo;

@property (nonatomic, strong) UIButton *caozuoDoneButton;
@end

@implementation WindowClerkTableViewCell
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
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(windowClerkButtonAction:withModel:)]) {
            [self.cellDelegate windowClerkButtonAction:index withModel:self.model];
        }
    };
    
    [contentUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    UIView *caozuoview = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:caozuoview];
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@"操作:"];
    [caozuoview addSubview:titleLabel];
    
    [caozuoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentUserInfo.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caozuoview.mas_top);
        make.left.mas_equalTo(caozuoview.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(caozuoview.mas_bottom);
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

- (UIButton *)createButtonWithTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSString *titleStr = [NSString stringWithFormat:@"[%@]",title];
    [button setTitle:titleStr forState:UIControlStateNormal];
    button.tag = index + 1000;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)setModel:(WindowClerkCellModel *)model
{
    _model = model;
}

- (void)buttonAction:(UIButton *)sender
{

    
}

@end
