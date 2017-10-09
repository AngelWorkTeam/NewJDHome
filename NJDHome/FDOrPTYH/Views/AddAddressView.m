//
//  AddAddressView.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "AddAddressView.h"
#import "AddressSelectView.h"
@interface AddAddressView()
@property (weak, nonatomic) IBOutlet UIView *addContainer;

@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (nonatomic,copy)  NSString *selectId;
@property (nonatomic,copy)  NSString *addr;
@property (nonatomic) BOOL keyboardShow;
@end
@implementation AddAddressView
-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:self options:nil][1];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow)
                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide)
                 name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)disMiss:(UITapGestureRecognizer *)sender {
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
- (IBAction)comfirmHandle:(id)sender {
    if (self.keyboardShow) {
        [self endEditing:YES];
        return;
    }
    if (self.textFeild.text.length < 6) {
        [NJDPopLoading showAutoHideWithMessage:@"地址输入不符合规定"];
        return;
    }
    self.addr = [self.addr stringByAppendingString:self.textFeild.text];
    !self.selectAddr?:self.selectAddr(self.selectId,self.addr);
    if (self.superview) {
        [self removeFromSuperview];
    }
}

-(void)showAt:(UIView *)view{
    self.frame = view.bounds;
    
    AddressSelectView *select = [AddressSelectView new];
    [self.container addSubview:select];
    [select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
    
    self.addContainer.layer.cornerRadius = 5.;
    self.addContainer.layer.masksToBounds = YES;
    @weakify(self);
    select.selectAddress = ^(NSArray *detailArr, NSString *address){
         @strongify(self);
        if (detailArr.count > 0) {
            NSDictionary *lastDic = [detailArr lastObject];
            self.selectId = lastDic[@"id"];
        }
        self.addr = address;
    };
    [select startShowAddr];
    [view addSubview:self];
    
}

-(void)keyboardShow:(NSNotification *)noti{
    self.addContainer.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.-64-80);
}
-(void)keyboardDismiss:(NSNotification *)noti{
    self.addContainer.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.-64);
    
}
-(void)keyboardDidShow{
    self.keyboardShow = YES;
}
-(void)keyboardDidHide{
    self.keyboardShow = NO;
}
@end
