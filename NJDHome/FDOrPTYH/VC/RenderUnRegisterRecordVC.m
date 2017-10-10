//
//  RenderUnRegisterRecordVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/7.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "RenderUnRegisterRecordVC.h"
#import "UnregisterVC.h"
#import "UnRegisterCell.h"
@interface RenderUnRegisterRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *table;
@end

@implementation RenderUnRegisterRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
}
-(void)initViews{
    [self createBackNavWithOpaque:YES];
    self.title = @"房客变更注销申报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(pushToUnregisterVC:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushToUnregisterVC:(UIBarButtonItem *)item{
    UnregisterVC *vc = [UnregisterVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
    
        _table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        [_table registerNib:[UINib nibWithNibName:@"UnRegisterCell" bundle:nil] forCellReuseIdentifier:@"UnRegisterCell"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *rows = self.dataSource[section];
//    return rows.count;
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
