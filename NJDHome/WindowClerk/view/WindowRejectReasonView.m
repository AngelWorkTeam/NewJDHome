//
//  WindowRejectReasonView.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/10/9.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowRejectReasonView.h"

@interface WindowRejectReasonView()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic)  BOOL keyboardShow;
@end

@implementation WindowRejectReasonView

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
        [self initData];
    }
    return self;
}


#pragma mark-键盘出现隐藏事件

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
    
    UILabel *titleLabel = [self createTitleLableWithTitle:@"退回"];
    titleLabel.textColor = [UIColor whiteColor];
    [TitlContenteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TitlContenteView.mas_left).offset(10);
        make.centerY.mas_equalTo(TitlContenteView.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    _titleLabel = titleLabel;

    
    UITextView *textView = [self createTextView];
    textView.text = @"请输入原因";
    [containerView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TitlContenteView.mas_bottom);
        make.left.mas_equalTo(containerView.mas_left);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(containerView.mas_right);
    }];
    _textView = textView;
    
    UIView *lastView = [UIView new];
    lastView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:lastView];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom);
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
    
    
    UIButton *acceptButton  = [self createButtonWithTitle:@"确定"];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    acceptButton.backgroundColor = [UIColor redColor];
    acceptButton.layer.cornerRadius = 5;
    [lastView addSubview:acceptButton];
    [acceptButton addTarget:self action:@selector(AcceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(40);
        make.centerY.mas_equalTo(lastView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *cancelButton  = [self createButtonWithTitle:@"取消"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor redColor];
    cancelButton.layer.cornerRadius = 5;
    [lastView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lastView.mas_centerX).offset(-40);
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

- (void)tapGestureAction:(UITapGestureRecognizer *)sender
{
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

- (void)AcceptAction:(UIButton *)sender
{
    NSString *reason = _textView.text;
    if (self.windrejectReasonAction) {
        self.windrejectReasonAction(reason);
    }
       [self dissmissFromsuperView];
}

- (void)cancelButtonAction:(UIButton *)sender
{
    [self dissmissFromsuperView];
    
}

- (void)dissmissFromsuperView
{
    if (self.superview) {
           [self removeFromSuperview];
    }
    
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
