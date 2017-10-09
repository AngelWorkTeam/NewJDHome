//
//  RequestHistoryViewController.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/8.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RequestHistoryViewController.h"
#import "ShenBaoProgressViewController.h"

#define YYScreenW [UIScreen mainScreen].bounds.size.width
#define YYScreenH [UIScreen mainScreen].bounds.size.height
#define YYMessageViewMinButton 2


@interface RequestHistoryViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, assign) CGFloat contentviewwidth ;

@property (nonatomic, strong) UIView *bottomLine;

@end



@implementation RequestHistoryViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTitleScrollView];
    
    [self setupContentScrollView];
    
    [self setupAllChildViewController];
    
    [self setupAllTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// 选中按钮
- (void)selButton:(UIButton *)button
{
    for(int i = 0 ; i < self.buttons.count; i++){
        UIButton *innerbutton = self.buttons[i];
        if (![innerbutton isEqual:button]) {
            [innerbutton setTitleColor:[UIColor colorWithHexString:@"4d4d4d"] forState:UIControlStateNormal];
        }
    }
    
    // 让按钮标题颜色变成红色
    //    _selectButton.transform = CGAffineTransformIdentity;
    //    [_selectButton setTitleColor:[UIColor colorWithHexString:@"4d4d4d"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"FF0000"] forState:UIControlStateNormal];
    // 按钮居中显示:本质修改titleScrollView的contentOffsetX
    CGFloat offsetX = button.center.x - YYScreenW * 0.5;
    
    self.bottomLine.centerX = button.center.x;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - YYScreenW;
    
    // 处理最大偏移量
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    //[self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    // 设置标题缩放
    // button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    _selectButton = button;
    
}

#pragma mark - UIScrollViewDelegate
// 只要滚动scrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger leftI = scrollView.contentOffset.x / YYScreenW;
    NSInteger rightI = leftI + 1;
    
    // 缩放按钮
    
    UIButton *leftButton = self.buttons[leftI];
    UIButton *rightButton = nil;
    NSInteger count = self.buttons.count;
    if (rightI < count) {
        rightButton = self.buttons[rightI];
    }
    // 缩放比例,根据滚动计算
    CGFloat scaleR = scrollView.contentOffset.x / YYScreenW - leftI;
    CGFloat scaleL = 1 - scaleR;
    
    // 0 ~ 1 => 1 ~ 1.3
    //    leftButton.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL  * 0.3 + 1);
    //    rightButton.transform = CGAffineTransformMakeScale(scaleR  * 0.3 + 1, scaleR  * 0.3 + 1);
    
    // 做颜色渐变 黑色 变成 红色
//    UIColor *colorR = [UIColor colorWithHexString:@"66666"];
//    UIColor *colorL = [UIColor colorWithHexString:@"FF0000"];
//
//    [leftButton setTitleColor:colorL forState:UIControlStateNormal];
//    [rightButton setTitleColor:colorR forState:UIControlStateNormal];
    
    CGFloat width = rightButton.width;
    self.bottomLine.centerX = leftButton.center.x + scaleR * width;
}

// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger i = scrollView.contentOffset.x / _contentviewwidth;
    
    UIButton *btn = self.buttons[i];
    
    [self selButton:btn];
    
    [self setupOneChildViewController:i];
    
}

// 切换控制器的view
- (void)setupOneChildViewController:(NSInteger)i{
    
    UIViewController *vc = self.childViewControllers[i];
    
    _contentviewwidth = YYScreenW ;
    if (vc.view.superview == nil) {
        CGFloat x = i * _contentviewwidth;
        vc.view.frame = CGRectMake(x, 0, _contentviewwidth, self.contentScrollView.frame.size.height);
        [self.contentScrollView addSubview:vc.view];
    }
}

// 点击标题就会调用
- (void)titleClick:(UIButton *)button
{
    NSInteger i = button.tag;
    
    [self selButton:button];
    
    [self setupOneChildViewController:i];
    
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}

// 设置标题
- (void)setupAllTitle
{
    NSInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat w = 100;
    CGFloat h = 35;
    
    if (count <= YYMessageViewMinButton) {
        w = YYScreenW / count;
    }
    
    for (int i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        titleButton.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor colorWithHexString:@"4D4D4D"] forState:UIControlStateNormal];
        x  = i * w;
        titleButton.frame = CGRectMake(x, 0, w, h);
        
        // 监听按钮标题
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScrollView addSubview:titleButton];
        
        [self.buttons addObject:titleButton];
        
        if (i == 0) {
            [self titleClick:titleButton];
        }
    }
    
    self.bottomLine.frame = CGRectMake(0, h - 2, w, 2);
    [self.titleScrollView addSubview:self.bottomLine];
    
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动视图滚动范围
    self.contentScrollView.contentSize = CGSizeMake(count * _contentviewwidth, 0);
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
}

//添加所有的子控制器
- (void)setupAllChildViewController
{
    
    if (self.childvcarrayDelegate && [self.childvcarrayDelegate respondsToSelector:@selector(yymessageChildViewControllerArray)]) {
        NSArray *vcarray =  [self.childvcarrayDelegate yymessageChildViewControllerArray];
        if (vcarray && vcarray.count > 0) {
            for (int i = 0; i < vcarray.count; i++) {
                UIViewController *vc = vcarray[i];
                [self addChildViewController:vc];
            }
        }
    }
    ShenBaoProgressViewController *shenbao =  [ShenBaoProgressViewController new];
    shenbao.title = @"申报进度查询";
    shenbao.shenbaoProgress = true;
    [self addChildViewController:shenbao];
    
    ShenBaoProgressViewController *ICcard = [ShenBaoProgressViewController new];
    ICcard.title = @"IC卡居住证申请记录";
    ICcard.shenbaoProgress = false;
    [self addChildViewController:ICcard];
    
}

// 添加顶部的标题滚动视图
- (void)setupTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    CGFloat y = 0;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 35;
    titleScrollView.frame = CGRectMake(0, y, w, h);
    titleScrollView.backgroundColor = [UIColor whiteColor];
    _titleScrollView = titleScrollView;
    [self.view addSubview:titleScrollView];
    
}

//添加底部的内容滚动视图
- (void)setupContentScrollView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat y = CGRectGetMaxY(_titleScrollView.frame);
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height - y;
    _contentScrollView = contentScrollView;
    contentScrollView.frame = CGRectMake(0, y, w, h);
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
}


- (NSArray<UIViewController *> *)yymessageChildViewControllerArray
{
    return @[];
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
    }
    return _bottomLine;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
