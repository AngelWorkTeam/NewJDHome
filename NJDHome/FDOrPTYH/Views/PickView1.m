//
//  PickView1.m
//  CSleepNew
//
//  Created by JustinYang on 16/8/24.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "PickView1.h"
@interface PickView1()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic,strong) UIPickerView *pick;


@property (nonatomic,strong) UILabel       *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end

@implementation PickView1
-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:self options:nil][3];
    if (self) {

        self.pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 48, kScreenWidth, 216)];
        self.pick.delegate = self;
        self.pick.dataSource = self;
        [self addSubview:self.pick];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_maskView) {
        CGRect bounds = self.superview.bounds;
        _maskView = [[UIView alloc] initWithFrame:bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:tap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 47, bounds.size.width, 0.5)];
        line.backgroundColor = self.comfirmLineColor==nil?[UIColor sam_colorWithHex:@"dddddd"]:self.comfirmLineColor;
        [self addSubview:line];
        
        self.pick.frame = CGRectMake(0, 48,kScreenWidth
                                     , self.bounds.size.height-48);
        
      
        for (UIView *view in self.pick.subviews) {
            if (view.frame.size.height < 1) {
                view.backgroundColor = self.pickViewLineColor==nil?[UIColor sam_colorWithHex:@"dddddd"]:self.pickViewLineColor;
            }
        }
        if (self.cancelColor) {
            [self.cancelBtn setTitleColor:self.cancelColor forState:UIControlStateNormal];
        }
        if (self.comfirmColor) {
            [self.comfirmBtn setTitleColor:self.comfirmColor forState:UIControlStateNormal];
        }
    }
    if (![self.superview.subviews containsObject:_maskView]) {
        [self.superview insertSubview:self.maskView belowSubview:self];
    }
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.pick reloadAllComponents];
}

#pragma mark - delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kScreenWidth;
}
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [NSString stringWithFormat:@"%@",self.dataArr[row]];
    CGFloat fontSize = self.pickFontSize < 10?10:self.pickFontSize;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:self.pickItemColor==nil?[UIColor blackColor]:self.pickItemColor,
                                                                                              NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    return attrStr;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
}
- (IBAction)comfirmHanlde:(id)sender {
    NSUInteger row = [self.pick selectedRowInComponent:0];
    if (row < self.dataArr.count) {
        !self.selectData?:self.selectData(self.dataArr[row],row);
    }
    [self dismiss];
}
- (IBAction)cancelHandle:(id)sender {
    [self dismiss];
}
-(void)dismiss{
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, BottomOfView(self), self.frame.size.width, self.frame.size.height);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        if (_maskView.superview) {
            [_maskView removeFromSuperview];
            _maskView  = nil;
        }
        [self removeFromSuperview];
    }];
    
}

-(void)setCurrentValue:(NSString *)currentValue{
    _currentValue = currentValue;
    NSInteger index = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",self.dataArr[i]];
        if ([currentValue isEqualToString:str]) {
            index = i;
            break;
        }
    }
    [self.pick selectRow:index inComponent:0 animated:NO];
    
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self.pick selectRow:currentIndex inComponent:0 animated:NO];
}
@end
