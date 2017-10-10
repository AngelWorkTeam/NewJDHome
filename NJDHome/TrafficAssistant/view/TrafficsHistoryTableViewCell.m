//
//  TrafficsHistoryTableViewCell.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficsHistoryTableViewCell.h"
#import "userInfoView.h"
@interface TrafficsHistoryTableViewCell ()


@property (nonatomic, strong) userInfoView  *contentUserInfo;
@end

@implementation TrafficsHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    userInfoView  *contentUserInfo = [[userInfoView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:contentUserInfo];
    _contentUserInfo = contentUserInfo;
    
    [contentUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    

    
}


- (void)setModel:(TrafficAssistantTaskModel *)model
{
    _model = model;
    
    _contentUserInfo.model = model;
}

@end
