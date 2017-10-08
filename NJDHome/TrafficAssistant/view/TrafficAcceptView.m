//
//  TrafficAcceptView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/6.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAcceptView.h"
#import "THDatePickerView.h"
@interface TrafficAcceptView ()<UIGestureRecognizerDelegate,THDatePickerViewDelegate>

@property (nonatomic, strong) UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *telephoneNumlabel;

@property (weak, nonatomic) IBOutlet UILabel *tempAddress;
@property (weak, nonatomic) IBOutlet UIButton *selectTime;


@property (weak, nonatomic) IBOutlet UITextView *suggestInfo;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapAction;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;

@property (weak, nonatomic) THDatePickerView *dateView;

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
}


- (IBAction)acceptAction:(id)sender {
    [self removeFromSuperview];
    
    NSString *timeStr = @"";
    NSString *userSuggest = @"";
    
    if (self.TraffiAcceptAction) {
        self.TraffiAcceptAction(timeStr, userSuggest);
    }
}
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
    
}
- (IBAction)tapAction:(id)sender {
    [self removeFromSuperview];
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
    
    _titleLabel.text = model.person ? model.person.name : @"";
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



@end
