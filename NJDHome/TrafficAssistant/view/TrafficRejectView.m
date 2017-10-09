//
//  TrafficAcceptView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficRejectView.h"
#import "PickView1.h"
@interface TrafficRejectView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *username;

@property (nonatomic, strong) UILabel *tempAddress;

@property (nonatomic, strong) UILabel *telePhone;

@property (nonatomic, strong) UIButton *selectTypeButton;

@property (nonatomic, strong) UITextView *userSuggest;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation TrafficRejectView

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
    
    CGFloat titleWidth = 55;
    
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
    
    UILabel *userNameTitle = [self createTitleLableWithTitle:@"姓名:"];
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
    
    UILabel *zanzhudizhiTitle = [self createTitleLableWithTitle:@"暂住地址:"];
    [containerView addSubview:zanzhudizhiTitle];
    [zanzhudizhiTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UILabel *tempAddress = [self createContentLableWithTitle:@""];
    [containerView addSubview:tempAddress];
    [tempAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameTitle.mas_bottom);
        make.left.mas_equalTo(zanzhudizhiTitle.mas_right);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    _tempAddress = tempAddress;
    
    UILabel *shoujihaomaTitle = [self createTitleLableWithTitle:@"手机号码:"];
    [containerView addSubview:shoujihaomaTitle];
    [shoujihaomaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zanzhudizhiTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UILabel *telePhone = [self createContentLableWithTitle:@""];
    [containerView addSubview:telePhone];
    [telePhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zanzhudizhiTitle.mas_bottom);
        make.left.mas_equalTo(shoujihaomaTitle.mas_right);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    _telePhone = telePhone;
    
    
    UILabel *tuihuiyuanyinTitle = [self createTitleLableWithTitle:@"退回原因:"];
    [containerView addSubview:tuihuiyuanyinTitle];
    [tuihuiyuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UIButton *getbackButton = [self createButtonWithTitle:@"本地户口无需登记" withIndex:10];
    [containerView addSubview:getbackButton];
    _selectTypeButton = getbackButton;
    [getbackButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [getbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(tuihuiyuanyinTitle.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [arrowImage setImage:[UIImage imageNamed:@"downMore"]];
    [containerView addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(getbackButton.mas_trailing).offset(-15);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(10);
        make.centerY.mas_equalTo(getbackButton.mas_centerY);
    }];

    UILabel *qitayuanyinTitle = [self createTitleLableWithTitle:@"其他原因:"];
    [containerView addSubview:qitayuanyinTitle];
    [qitayuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tuihuiyuanyinTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(titleWidth);
    }];
    
    
    UITextView *textView = [self createTextView];
    [containerView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tuihuiyuanyinTitle.mas_bottom);
        make.left.mas_equalTo(qitayuanyinTitle.mas_right);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    
    UIView *lastView = [UIView new];
    lastView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:lastView];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qitayuanyinTitle.mas_bottom);
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
    
    
    UIButton *acceptButton  = [self createButtonWithTitle:@"接受"];
    [lastView addSubview:acceptButton];
    [acceptButton addTarget:self action:@selector(AcceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(-40);
        make.centerY.mas_equalTo(lastView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *rejectButton  = [self createButtonWithTitle:@"拒绝"];
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

- (UITextView *)createTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1;
    
    return textView;
}

- (void)setModel:(TrafficAssistantTaskModel *)model
{
    _model = model;
    
    _username.text = model.person ? model.person.name : @"";
    _tempAddress.text = model.temporaryAddress;
    _telePhone.text = model.telephoneNumber;
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}


- (void)buttonAction:(UIButton *)sender
{
    if (_rejectReasonArray && _rejectReasonArray.count > 0) {
        [self popPickWithData:_rejectReasonArray selectRow:^(NSInteger index) {
            NSString *title = _rejectReasonArray[index];
            [_selectTypeButton setTitle:title forState:UIControlStateNormal];
            
            CGRect imageRect = _selectTypeButton.imageView.frame;
            CGRect titleRect = _selectTypeButton.titleLabel.frame;
            _selectTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleRect.size.width, 0,-titleRect.size.width);
            _selectTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageRect.size.width, 0, imageRect.size.width);
            
        }];
    }
}


- (void)AcceptAction:(UIButton *)sender
{
    NSString *reason = _selectTypeButton.titleLabel.text;
    NSString *otherSuggest = _userSuggest.text;
    if (!otherSuggest) {
        otherSuggest = @"";
    }
    
    if (self.TrafficRejectAction) {
        self.TrafficRejectAction(reason, otherSuggest);
    }
}

- (void)RejectAction:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)ges
{
    [self removeFromSuperview];
}

- (void)setRejectReasonArray:(NSMutableArray *)rejectReasonArray
{
    _rejectReasonArray = rejectReasonArray;
    if(_rejectReasonArray && _rejectReasonArray.count > 0){
        NSString *title = _rejectReasonArray[0];
        [_selectTypeButton setTitle:title forState:UIControlStateNormal];
        
        CGRect imageRect = _selectTypeButton.imageView.frame;
        CGRect titleRect = _selectTypeButton.titleLabel.frame;
        _selectTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleRect.size.width, 0,-titleRect.size.width);
        _selectTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageRect.size.width, 0, imageRect.size.width);
    }
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


@end
