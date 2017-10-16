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
@property (nonatomic, strong) UILabel *beizhuContent;
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
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@"备注:"];
    [caozuoview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caozuoview.mas_top);
        make.left.mas_equalTo(caozuoview.mas_left);
        make.width.mas_equalTo(70);
        make.bottom.mas_equalTo(caozuoview.mas_bottom);
    }];
    
    _beizhuContent  = [self createTitleLableWithTitle:@"备注:"];
    _beizhuContent.textColor = [UIColor redColor];
    _beizhuContent.preferredMaxLayoutWidth = njdScreenWidth - 10*2 - 60;
    [_beizhuContent setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _beizhuContent.numberOfLines = 0;
    [caozuoview addSubview:_beizhuContent];
    
    [_beizhuContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caozuoview.mas_top);
        make.left.mas_equalTo(titleLabel.mas_right);
        make.right.mas_equalTo(caozuoview.mas_right);
        make.bottom.mas_equalTo(caozuoview.mas_bottom);
    }];

    [caozuoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentUserInfo.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

- (UILabel *)createTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
    titleLable.font = [UIFont systemFontOfSize:15];
    return titleLable;
}

- (void)setModel:(WindowClerkCellModel *)model
{
    _model = model;
    
    _contentUserInfo.model = model;
    if ([model.takeType isEqualToString:@"1"]) {
        _beizhuContent.text = @"居住证办理完成，可带身份证到辖区派出所自行领取！";
    }else if([model.takeType isEqualToString:@"2"]) {
        _beizhuContent.text = @"居住证已通过到付的形式寄往您的住处，请注意查收！";
    }
}

- (void)setHiddenIDCardImageButton:(BOOL)hiddenIDCardImageButton
{
    _hiddenIDCardImageButton = hiddenIDCardImageButton;
    _contentUserInfo.hiddenIDCardImageButton = hiddenIDCardImageButton;
    
}



@end
