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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@property (weak, nonatomic) IBOutlet UILabel *telephoneNumlabel;

@property (weak, nonatomic) IBOutlet UILabel *tempAddress;
@property (weak, nonatomic) IBOutlet UIButton *selectTime;


@property (weak, nonatomic) IBOutlet UITextView *suggestInfo;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapAction;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;

@property (weak, nonatomic) THDatePickerView *dateView;

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

-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"TrafficAccept" owner:self options:nil][0];
   [self initContentView];
    [self createTimeSeleect];
    [self initData];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
        [self createTimeSeleect];
    }
    return self;
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
    self.suggestInfo.layer.borderColor = [UIColor grayColor].CGColor;
    self.suggestInfo.layer.borderWidth = 1;
    self.suggestInfo.delegate = self;
 
    CGRect imageRect = _selectTimeButton.imageView.frame;
    CGRect titleRect = _selectTimeButton.titleLabel.frame;
    _selectTimeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleRect.size.width, 0,-titleRect.size.width);
    _selectTimeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageRect.size.width, 0, imageRect.size.width);
}


- (IBAction)acceptAction:(id)sender {
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
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
    
}
- (IBAction)tapAction:(UIGestureRecognizer *)sender {
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

- (IBAction)selectTimeAction:(id)sender {
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
    CGRect imageRect = _selectTimeButton.imageView.frame;
    CGRect titleRect = _selectTimeButton.titleLabel.frame;
    _selectTimeButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleRect.size.width, 0,-titleRect.size.width);
    _selectTimeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageRect.size.width, 0, imageRect.size.width);
    
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
