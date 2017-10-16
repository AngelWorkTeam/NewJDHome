//
//  TrafficAssistantTableViewCell.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAssistantTableViewCell.h"

@interface TrafficAssistantTableViewCell ()

@property (nonatomic, strong) NSArray *buttonTitleArray;

@property (nonatomic, strong) userInfoView  *contentUserInfo;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

CGFloat trafficCellLabelFontSize = 15.0;

@implementation TrafficAssistantTableViewCell

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
    _buttonArray = [NSMutableArray new];
    
    userInfoView  *contentUserInfo = [[userInfoView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:contentUserInfo];
    _contentUserInfo = contentUserInfo;
    
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
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(caozuoview.mas_top);
        make.left.mas_equalTo(caozuoview.mas_left);
        make.width.mas_equalTo(70);
        make.bottom.mas_equalTo(caozuoview.mas_bottom);
    }];
    
    _buttonTitleArray = @[@"受理",@"退回",@"转交"];
    UIView *lastView = titleLabel;
    for (int i = 0; i < _buttonTitleArray.count; i++) {
        
        UIButton *button = [self createButtonWithTitle:[NSString stringWithFormat:@"[%@]",_buttonTitleArray[i]] withIndex:i+1000];
        [caozuoview addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(caozuoview.mas_top);
            make.left.mas_equalTo(lastView.mas_right);
            make.width.mas_equalTo(75);
            make.bottom.mas_equalTo(caozuoview.mas_bottom);
        }];
        lastView = button;
        [_buttonArray addObject:button];
    }
}

- (void)setModel:(TrafficAssistantTaskModel *)model
{
    _model = model;
    
    _contentUserInfo.model = model;
    
    if([_model.state isEqualToString:@"1"]){
        UIButton *firstButton = _buttonArray[0];
        UIButton *secondButton = _buttonArray[1];
        UIButton *thirdButton = _buttonArray[2];
        [firstButton setTitle:@"[受理]" forState:UIControlStateNormal];
        secondButton.hidden = false;
        thirdButton.hidden = false;
        
    }else if ([_model.state isEqualToString:@"2"]){
        if ([_model.type isEqualToString:@"0"]) {    // 注销
            UIButton *firstButton = _buttonArray[0];
            UIButton *secondButton = _buttonArray[1];
            UIButton *thirdButton = _buttonArray[2];
            [firstButton setTitle:@"[注销登记]" forState:UIControlStateNormal];
            secondButton.hidden = true;
            thirdButton.hidden = true;
        }else if ([_model.type isEqualToString:@"2"]){   // 变更
            UIButton *firstButton = _buttonArray[0];
            UIButton *secondButton = _buttonArray[1];
            UIButton *thirdButton = _buttonArray[2];
            [firstButton setTitle:@"[变更登记]" forState:UIControlStateNormal];
            secondButton.hidden = true;
            thirdButton.hidden = true;
        }else if ([_model.type isEqualToString:@"1"]){  // 申报
            UIButton *firstButton = _buttonArray[0];
            UIButton *secondButton = _buttonArray[1];
            UIButton *thirdButton = _buttonArray[2];
            [firstButton setTitle:@"[申报登记]" forState:UIControlStateNormal];
            secondButton.hidden = true;
            thirdButton.hidden = true;
        }
        
    }
    
}


- (UILabel *)createTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
    titleLable.font = [UIFont systemFontOfSize:trafficCellLabelFontSize];
    return titleLable;
}



- (UIButton *)createButtonWithTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = index;
    button.layer.cornerRadius = 3;
    button.titleLabel.font = [UIFont systemFontOfSize:trafficCellLabelFontSize];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    NSInteger index = tag - 1000;
    
    if (self.trafficAction) {
        self.trafficAction(index,_buttonTitleArray[tag]);
    }
    
    if(self.cellDelgate && [self.cellDelgate respondsToSelector:@selector(trafficActionButtonAction:withModel:)]){
        [self.cellDelgate trafficActionButtonAction:index withModel:_model];
    }
}

@end
