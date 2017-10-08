//
//  TermVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/5.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TermVC.h"
#import <WebKit/WebKit.h>
#import "ApplyCardVC.h"
#define kBtnRemainHeight 65
@interface TermVC ()<WKNavigationDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic) CGFloat webHeight;
@end

@implementation TermVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self createBackNavWithOpaque:YES];
}
-(void)initViews{
    [self createBackNavWithOpaque:YES];
    self.title = @"检查流程";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-kBtnRemainHeight)];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"description" ofType:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setAttributedTitle:[[NSAttributedString alloc]
                             initWithString:@"下一步"
                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSForegroundColorAttributeName:[UIColor whiteColor]
                                          }]
                   forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = [UIColor redColor];
    self.nextBtn.layer.cornerRadius = 5.;
    self.nextBtn.layer.masksToBounds = YES;
    [self.nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.frame = CGRectMake(16, kScreenHeight-64-16-40, kScreenWidth -32, 40);
    [self.scrollView addSubview:self.nextBtn];
    
}
-(void)nextStep:(UIButton *)btn{
    ApplyCardVC *vc = [ApplyCardVC new];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [NJDPopLoading showAutoHideWithMessage:@"加载出错"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.offsetHeight"
              completionHandler:^(id _Nullable value, NSError * _Nullable error) {
                  CGFloat height = [value floatValue];
                  self.webHeight = height+30;
                  
              }];
}
-(void)setWebHeight:(CGFloat)webHeight{
    _webHeight = webHeight;
    if (webHeight > kScreenHeight-64 - kBtnRemainHeight) {
        CGRect frame =self.webView.frame;
        frame.size.height = webHeight;
        self.webView.frame = frame;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, webHeight+kBtnRemainHeight);
        self.nextBtn.frame = CGRectMake(16, webHeight + 8, kScreenWidth-32, 40);
    }
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
