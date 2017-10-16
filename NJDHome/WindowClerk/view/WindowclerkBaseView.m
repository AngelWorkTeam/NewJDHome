//
//  WindowclerkBaseView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowclerkBaseView.h"

@interface WindowclerkBaseView ()

@property (nonatomic, strong) NSArray *titleArray;


@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *shenfenzhenghaoLabel;

@property (nonatomic, strong) UILabel *dianhuahaomaLabel;

@property (nonatomic, strong) UILabel *hujidizhiLabel;

@property (nonatomic, strong) UILabel *xianzhudizhiLabel;

@property (nonatomic, strong) UILabel *quzhengfangshiLabel;

@property (nonatomic, strong) UILabel *shengqingshijianLabel;

@property (nonatomic, strong) UILabel *banlizhuangtaiLabel;

@property (nonatomic, strong) UILabel *chakanzhaopianLabel;

@property (nonatomic, strong) UIButton *ziliaozhaopianButton; //资料照片

@property (nonatomic, strong) UIButton *shengfengzhengButton; // 身份证照片

@property (nonatomic, strong) UIButton *renlianzhaopianButton; // 人脸照片

@property (nonatomic, strong) NSArray *buttonTitleArray;

@end

CGFloat windowclerkLabelFontSize = 15.0;

@implementation WindowclerkBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView ];
    }
    return self;
}

- (void)initContentView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _titleArray = @[@"姓名:",@"身份证号:",@"电话号码:",@"户籍地址:",@"现住地址:",@"取证方式:",@"申请时间:",@"办理状态:"];
    
    UIView *lastview ;
    for (int i  = 0 ; i < _titleArray.count ; i++) {
        UIView *cellView = [self createCellViewWithTitle:_titleArray[i]];
        [contentView addSubview:cellView];
        if (i == 0) {
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contentView.mas_top);
                make.left.mas_equalTo(contentView.mas_left);
                make.right.mas_equalTo(contentView.mas_right);
                make.height.mas_equalTo(windowclekcellHeight);
            }];
            
        }else{
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastview.mas_bottom);
                make.left.mas_equalTo(contentView.mas_left);
                make.right.mas_equalTo(contentView.mas_right);
            }];
        }
        lastview = cellView;
    }
    
    
    UIView *chaokanzhaopianView = [self createLastViewToViewPhoto];
    [contentView addSubview:chaokanzhaopianView];
    [chaokanzhaopianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastview.mas_bottom);
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.bottom.mas_equalTo(contentView.mas_bottom);
    }];
}

- (UIView *)createLastViewToViewPhoto
{
    UIView *cellview = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@"查看照片:"];
    [cellview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellview.mas_top);
        make.left.mas_equalTo(cellview.mas_left);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(cellview.mas_bottom);
    }];
    
    NSArray *buttonArray = @[@"资料照片",@"身份证照",@"人脸照片"];
    _buttonTitleArray = buttonArray;
    UIView *leftView = titleLabel;
    for(int i = 0; i < buttonArray.count ; i++){
        UIButton *button = [self createButtonWithTitle:buttonArray[i] withIndex:i];
        [cellview addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cellview.mas_top);
            make.left.mas_equalTo(leftView.mas_right).offset(10);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(30);
        }];
        leftView = button;
        if (i == 0) {
            _ziliaozhaopianButton = button;
        }else if( i == 1){
            _shengfengzhengButton = button;
        }else if(i == 2){
            _renlianzhaopianButton = button;
        }
    }
    
    return cellview;
}

- (UIView *)createCellViewWithTitle:(NSString *)title
{
    UIView *cellview = [[UIView alloc]initWithFrame:CGRectZero];
    
    CGFloat titleWidth = 70;
    
    UILabel *titleLabel = [self createTitleLableWithTitle:title];
    [cellview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellview.mas_top);
        make.left.mas_equalTo(cellview.mas_left);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(windowclekcellHeight);
    }];
    
    UILabel *contentLabel = [self createContentLableWithTitle:@""];
    contentLabel.preferredMaxLayoutWidth = njdScreenWidth - 10*2 - titleWidth;
    [contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    contentLabel.numberOfLines = 0;
    [cellview addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellview.mas_top);
        make.left.mas_equalTo(titleLabel.mas_right);
        make.bottom.mas_equalTo(cellview.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(windowclekcellHeight);
    }];
    
    
    if ([_titleArray containsObject:title]) {
        NSInteger index = [_titleArray indexOfObject:title];
        switch (index) {
            case 0:
                _userNameLabel = contentLabel;
                break;
            case 1:
                _shenfenzhenghaoLabel = contentLabel;
                break;
            case 2:
                _dianhuahaomaLabel = contentLabel;
                break;
            case 3:
                _hujidizhiLabel = contentLabel;
                break;
            case 4:
                _xianzhudizhiLabel = contentLabel;
                break;
            case 5:
                _quzhengfangshiLabel = contentLabel;
                break;
            case 6:
                _shengqingshijianLabel = contentLabel;
                break;
            case 7:
                _banlizhuangtaiLabel = contentLabel;
                _banlizhuangtaiLabel.textColor = [UIColor redColor];
                break;
            case 8:
                _chakanzhaopianLabel = contentLabel;
                break;
            default:
                break;
        }
    }
    
    
    return cellview;
}


- (UILabel *)createTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
    titleLable.font = [UIFont systemFontOfSize:windowclerkLabelFontSize];
    titleLable.numberOfLines = 0;
    return titleLable;
}

- (UILabel *)createContentLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"999999"];
    titleLable.font = [UIFont systemFontOfSize:windowclerkLabelFontSize];
    return titleLable;
}

- (UIButton *)createButtonWithTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSString *titleStr = [NSString stringWithFormat:@"[%@]",title];
    [button setTitle:titleStr forState:UIControlStateNormal];
    button.tag = index + 1000;
    button.titleLabel.font = [UIFont systemFontOfSize:windowclerkLabelFontSize];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    NSInteger index = tag - 1000;
    
    if (self.windowAction) {
        self.windowAction(index,_buttonTitleArray[index]);
    }
}


- (void)setModel:(WindowClerkCellModel *)model
{
    _model = model;
    
    _userNameLabel.text = model.person ? model.person.name :@"";
    _shenfenzhenghaoLabel.text = model.person ? model.person.identityCard :@"";
    _dianhuahaomaLabel.text = model.telephoneNumber;
    _hujidizhiLabel.text = model.person ? model.person.oldAddress : @"";
    _xianzhudizhiLabel.text = model.address;
    
    _quzhengfangshiLabel.text = @"";
    if ([model.takeType isEqualToString:@"1"]) {
        _quzhengfangshiLabel.text = @"上门自取";
    }else if([model.takeType isEqualToString:@"2"]) {
        _quzhengfangshiLabel.text = @"邮寄到付";
    }
    
    _shengqingshijianLabel.text = model.submitDateTime;
    
    NSString *stateStr = @"";
    if ([model.state isEqualToString:@"-1"]) {
        stateStr = @"退回";
    }else  if ([model.state isEqualToString:@"0"]) {
        stateStr = @"租户提交";
    }else  if ([model.state isEqualToString:@"1"]) {
        stateStr = @"办理中";
    } else if ([model.state isEqualToString:@"2"]) {
        stateStr = @"办理完成";
    }
    _banlizhuangtaiLabel.text = stateStr;
    
}

- (void)setHiddenIDCardImageButton:(BOOL)hiddenIDCardImageButton
{
    _hiddenIDCardImageButton = hiddenIDCardImageButton;
    _shengfengzhengButton.hidden = hiddenIDCardImageButton;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
