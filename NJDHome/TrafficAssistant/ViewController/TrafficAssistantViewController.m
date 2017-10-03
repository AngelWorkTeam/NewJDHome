//
//  TrafficAssistantViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAssistantViewController.h"

@interface TrafficAssistantViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView   *tabbarView;

@property (nonatomic, strong) UIButton *NewTaskQueryButton;

@property (nonatomic, strong) UIButton *HistoryTaskQueryButton;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *datasoureArray;
@end

#define tabarHeight 49

@implementation TrafficAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasoureArray = [NSMutableArray new];
    [self createNoBackWithOpaue:YES];
    
    [self.view addSubview:self.table];
    [self.view addSubview:self.tabbarView];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-tabarHeight);
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createNoBackWithOpaue:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasoureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xgyReuseCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xgyReuseCell"];
        
    }
    
    return cell;
    
}

- (void)NewTaskButtonAction:(UIButton *)sender
{

}

- (void)HistoryTaskButtonAction:(UIButton *)sender
{

}

- (UIView *)tabbarView
{
    if (_tabbarView == nil) {
        _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - tabarHeight, kScreenWidth, tabarHeight)];
        _tabbarView.backgroundColor = [UIColor redColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_tabbarView addSubview:lineView];
        
        [_tabbarView addSubview:self.HistoryTaskQueryButton];
        [_tabbarView addSubview:self.NewTaskQueryButton];
        
    }
    return _tabbarView;
}

- (UIButton *)HistoryTaskQueryButton
{
    if (_HistoryTaskQueryButton == nil) {
        _HistoryTaskQueryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, tabarHeight)];
        [_HistoryTaskQueryButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_HistoryTaskQueryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_HistoryTaskQueryButton setTitle:@"历史任务查询" forState:UIControlStateNormal];
        [_HistoryTaskQueryButton addTarget:self action:@selector(HistoryTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _NewTaskQueryButton;
}

- (UIButton *)NewTaskQueryButton
{
    if (_NewTaskQueryButton == nil) {
        _NewTaskQueryButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, tabarHeight)];
        [_NewTaskQueryButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_NewTaskQueryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_NewTaskQueryButton setTitle:@"新任务查询" forState:UIControlStateNormal];
        [_NewTaskQueryButton addTarget:self action:@selector(NewTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _NewTaskQueryButton;
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate  = self;
        _table.dataSource = self;
        
    }
    return _table;
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
