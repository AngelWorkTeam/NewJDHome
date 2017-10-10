//
//  TrafficAcceptView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAcceptView.h"
#import "THDatePickerView.h"
@interface TrafficAcceptView ()<UIGestureRecognizerDelegate,THDatePickerViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *userName;


@property (strong, nonatomic)  UILabel *telephoneNumlabel;

@property (strong, nonatomic)  UILabel *tempAddress;


@property (strong, nonatomic)  UITextView *suggestInfo;
@property (strong, nonatomic)  UITapGestureRecognizer *tapAction;
@property (strong, nonatomic)  UIButton *selectTimeButton;

@property (strong, nonatomic) THDatePickerView *dateView;

@property (nonatomic)  BOOL keyboardShow;
@end

@implementation TrafficAcceptView

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
        [self initContentView];
        [self createTimeSeleect];
    }
    return self;
}


- (void)createTimeSeleect
{
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, njdScreenHeight, njdScreenWidth, 300)];
    dateView.delegate = self;
    dateView.title = @"请选择时间";
    [self addSubview:dateView];
    self.dateView = dateView;
}

- (void)initContentView
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
    
    _tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_backView addGestureRecognizer:_tapAction];
    
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
    _userName = userName;
    
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
    _telephoneNumlabel = telePhone;
    
    UIView *xuanzeriqibackview = [UIView new];
    [containerView addSubview:xuanzeriqibackview];
    xuanzeriqibackview.backgroundColor = [UIColor yellowColor];
    [xuanzeriqibackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    
    UILabel *tuihuiyuanyinTitle = [self createTitleLableWithTitle:@"核查时间:"];
    [xuanzeriqibackview addSubview:tuihuiyuanyinTitle];
    //_tuihuiyuanyinTitle = tuihuiyuanyinTitle;
    [tuihuiyuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UILabel *riqiTitleLabel = [self createTitleLableWithTitle:@"日期:"];
    [xuanzeriqibackview addSubview:riqiTitleLabel];
    //_tuihuiyuanyinTitle = tuihuiyuanyinTitle;
    [riqiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(tuihuiyuanyinTitle.mas_right).offset(2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(titleWidth);
    }];
    
    UIButton *getbackButton = [self createButtonWithTitle:@"选择日期" withIndex:10];
    [xuanzeriqibackview addSubview:getbackButton];
    _selectTimeButton = getbackButton;
    [getbackButton addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [getbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shoujihaomaTitle.mas_bottom);
        make.left.mas_equalTo(riqiTitleLabel.mas_right).offset(2);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [arrowImage setImage:[UIImage imageNamed:@"downMore"]];
    [xuanzeriqibackview addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(getbackButton.mas_trailing).offset(-15);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(10);
        make.centerY.mas_equalTo(getbackButton.mas_centerY);
    }];
    
    UILabel *explanLabel = [self createTitleLableWithTitle:@"不需要上门核查的不需要填写日期"];
    explanLabel.font = [UIFont systemFontOfSize:12];
    explanLabel.textColor = [UIColor redColor];
    [xuanzeriqibackview addSubview:explanLabel];
    //_tuihuiyuanyinTitle = tuihuiyuanyinTitle;
    [explanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xuanzeriqibackview.mas_bottom).offset(-30);
        make.left.mas_equalTo(tuihuiyuanyinTitle.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(xuanzeriqibackview.mas_right);
    }];
    
    UILabel *qitayuanyinTitle = [self createTitleLableWithTitle:@"其他原因:"];
    [containerView addSubview:qitayuanyinTitle];
   // _qitayuanyinTitle = qitayuanyinTitle;
    [qitayuanyinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xuanzeriqibackview.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(titleWidth);
    }];
    
    
    UITextView *textView = [self createTextView];
    [containerView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xuanzeriqibackview.mas_bottom);
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
    
    
    UIButton *acceptButton  = [self createButtonWithTitle:@"提交"];
    [lastView addSubview:acceptButton];
   // _acceptButton = acceptButton;
    [acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(-40);
        make.centerY.mas_equalTo(lastView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *rejectButton  = [self createButtonWithTitle:@"关闭"];
    [lastView addSubview:rejectButton];
    [rejectButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
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
    button.layer.cornerRadius = 3;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return button;
}

- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 3;
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



- (void)acceptAction:(id)sender {
    [self removeFromSuperview];
    
    NSString *checkDate = nil;
    NSString *checkTime = nil;
    NSString *timeStr = _selectTimeButton.titleLabel.text;
    if (![timeStr isEqualToString:@"选择日期"] ) {
        NSLog(@"日期: %@", timeStr);
        NSArray *timerArray = [timeStr componentsSeparatedByString:@" "];
        if (timerArray.count == 2) {
            checkDate = timerArray[0];
            checkTime = timerArray[1];
        }
    }
    
    NSString *userSuggest = _suggestInfo.text;
    if (!(userSuggest && userSuggest.length > 0)) {
        userSuggest = @"";
    }
    
    if (self.TraffiAcceptAction) {
        self.TraffiAcceptAction(checkDate,checkTime, userSuggest);
    }
}
- (void)closeAction:(id)sender {
    [self removeFromSuperview];
    
}
- (void)tapAction:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded&&
        self.keyboardShow == NO) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }else if(sender.state == UIGestureRecognizerStateEnded&&
             self.keyboardShow == YES){
        [self endEditing:YES];
    }
}

- (void)selectTimeAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, njdScreenHeight - 300, njdScreenWidth, 300);
        [self.dateView show];
    }];
}

- (void)setModel:(TrafficAssistantTaskModel *)model
{
    _model = model;
    
    _userName.text = model.person ? model.person.name : @"";
    _tempAddress.text = model.temporaryAddress;
    _telephoneNumlabel.text = model.telephoneNumber;
    
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击 %@", timer);
    [_selectTimeButton setTitle:timer forState:UIControlStateNormal];

    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, njdScreenHeight, njdScreenWidth, 300);
    }];
}


/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, njdScreenHeight, njdScreenWidth, 300);
    }];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(void)initData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)noti{
  
    // self.tooBar.frame = rect;

    
    NSDictionary *userInfo = [noti userInfo];
    CGRect rect= [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y - 50));
    }];
}
-(void)keyboardDismiss:(NSNotification *)notification{
    //self.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.-64);
    //获得通知中的info字典
    [UIView animateWithDuration:0.25 animations:^{
        //恢复原样
        self.transform = CGAffineTransformIdentity;
        //        commentView.hidden = YES;
    }];
}
-(void)keyboardDidShow{
    self.keyboardShow = YES;
}
-(void)keyboardDidHide{
    self.keyboardShow = NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
