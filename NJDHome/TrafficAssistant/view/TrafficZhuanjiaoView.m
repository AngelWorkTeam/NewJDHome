//
//  TrafficZhuanjiaoView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficZhuanjiaoView.h"
#import "PickView1.h"
@interface TrafficZhuanjiaoView ()  <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *username;

@property (nonatomic, strong) UIButton *selectXGYNameButton;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation TrafficZhuanjiaoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
        
    }
    return self;
}


- (void)initContent
{
    
    CGFloat titleWidth = 80;
    
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [_backView addGestureRecognizer:_tap];
    
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:containerView];
    
    UIView *TitlContenteView = [UIView new];
    TitlContenteView.backgroundColor = [UIColor redColor];
    [containerView addSubview:TitlContenteView];
    [TitlContenteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(containerView);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@""];
    titleLabel.textColor = [UIColor whiteColor];
    [TitlContenteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TitlContenteView.mas_left).offset(10);
        make.centerY.mas_equalTo(TitlContenteView.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    _titleLabel = titleLabel;
    
    UILabel *userNameTitle = [self createTitleLableWithTitle:@"申请人姓名:"];
    [containerView addSubview:userNameTitle];
    [userNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TitlContenteView.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UILabel *userName = [self createContentLableWithTitle:@""];
    [containerView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TitlContenteView.mas_bottom);
        make.left.mas_equalTo(userNameTitle.mas_right);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(TitlContenteView.mas_right);
    }];
    _username = userName;
    
    UIView *yellowBackView = [[UIView alloc]initWithFrame:CGRectZero];
    [containerView addSubview:yellowBackView];
    [yellowBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    
    UILabel *tuihuiyuanyinTitle = [self createTitleLableWithTitle:@"转交协管员:"];
    [yellowBackView addSubview:tuihuiyuanyinTitle];
    [tuihuiyuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowBackView.mas_top);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(titleWidth);
    }];
    
    
  
    
    UIButton *getbackButton = [self createButtonWithTitle:@"" withIndex:10];
    [yellowBackView addSubview:getbackButton];
    _selectXGYNameButton = getbackButton;
    [getbackButton addTarget:self action:@selector(selectionXGYName:) forControlEvents:UIControlEventTouchUpInside];
    [getbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowBackView.mas_top);
        make.left.mas_equalTo(tuihuiyuanyinTitle.mas_right);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    

    
    UIView *lastView = [UIView new];
    lastView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:lastView];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yellowBackView.mas_bottom);
        make.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(containerView.mas_bottom);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.centerY.mas_equalTo(contentView.mas_centerY);
        make.left.mas_equalTo(contentView.mas_left).offset(10);
        make.right.mas_equalTo(contentView.mas_right).offset(-10);
    }];
    
    
    UIButton *acceptButton  = [self createButtonWithTitle:@"转交"];
    [lastView addSubview:acceptButton];
    [acceptButton addTarget:self action:@selector(AcceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(-40);
        make.centerY.mas_equalTo(lastView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *rejectButton  = [self createButtonWithTitle:@"关闭"];
    [lastView addSubview:rejectButton];
    [rejectButton addTarget:self action:@selector(RejectAction:) forControlEvents:UIControlEventTouchUpInside];
    [rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(40);
        make.centerY.mas_equalTo(lastView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
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

- (UILabel *)createContentLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"999999"];
    titleLable.font = [UIFont systemFontOfSize:12];
    return titleLable;
}

- (UIButton *)createButtonWithTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = index;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return button;
}

- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return button;
}

-(void)popPickWithData:(NSArray *)datas
             selectRow:(void (^)(NSInteger index))select{

    
    PickView1 *pickView1 = [PickView1 new];
    pickView1.selectData = ^(NSString *element, NSInteger index){
        !select?:select(index);
    };
    pickView1.dataArr = datas;
    [[UIApplication sharedApplication].keyWindow addSubview:pickView1];
    pickView1.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 218);
    
    [UIView animateWithDuration:0.4 animations:^{
        pickView1.frame = CGRectMake(0, kScreenHeight-218, kScreenWidth, 218);
    }];
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)AcceptAction:(UIButton *)sender
{
     if (_xgyArray && _xgyArray.count > 0) {
        if (self.zhuanjiaoAction  ) {
            NSString *name = _selectXGYNameButton.titleLabel.text;
            
            self.zhuanjiaoAction(name);
        }
     }
}

- (void)RejectAction:(UIButton *)sender
{
     [self removeFromSuperview];
}

- (void)selectionXGYName:(UIButton *)sender
{
    if (_xgyArray && _xgyArray.count > 0) {
        [self popPickWithData:_xgyArray selectRow:^(NSInteger index) {
            NSString *titleArray = _xgyArray[index];
            [sender setTitle:titleArray forState:UIControlStateNormal];
        }];
    }
}

- (void)setXgyArray:(NSMutableArray *)xgyArray
{
    _xgyArray = xgyArray;

}


- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}
@end
