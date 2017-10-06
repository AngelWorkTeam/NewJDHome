//
//  TrafficAssistantViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAssistantViewController.h"
#import "SettingVC.h"
#import "TrafficAssistantTableViewCell.h"
#import "TrafficsHistoryTableViewCell.h"
#import "TrafficAssistantTaskModel.h"
#import "NetworkingManager+YYNetRequest.h"
#import <MJRefresh.h>
#import "NJDRefreshHeader.h"
@interface TrafficAssistantViewController ()<UITableViewDelegate, UITableViewDataSource, TrafficAssistantTableViewCellDelegate>

@property (nonatomic, strong) UIView   *tabbarView;

@property (nonatomic, strong) UIButton *NewTaskQueryButton;

@property (nonatomic, strong) UIButton *HistoryTaskQueryButton;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *datasoureArray;

@property (nonatomic, assign) BOOL isNewTask;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL  isLast;
@end

#define tabarHeight 49


@implementation TrafficAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datasoureArray = [NSMutableArray new];
    _isNewTask = true;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self initViews];
    
    
    [self.view addSubview:self.table];

    [self.view addSubview:self.tabbarView];
    
    _page = 0;
    _isLast = false;
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _isLast = false;
        [self reloadTrafficData];
    }];

//    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(-header.height);
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-tabarHeight);
//    }];
    self.table.mj_header =  header;   // 马上进入刷新状态
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = true;
    
    [self.table.mj_header beginRefreshing];
    self.table.mj_header.automaticallyChangeAlpha = YES;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (!_isLast) {
            _page += 1;
            [self reloadTrafficData ];
        }
        
    }];

    self.table.mj_footer = footer;
    [footer setTitle:@"上拉加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
}

#pragma mark - privte metod
-(void)initViews{
    [self createNoBackWithOpaue:YES];
    self.title = @"新金东人之家";
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"efeff6"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"设置" style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(settingHandle:)];
}

#pragma mark - action handle
-(void)settingHandle:(UIBarButtonItem *)item{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingVC *vc =[sb instantiateViewControllerWithIdentifier:@"settingVC"];
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
   return _datasoureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isNewTask) {
        TrafficAssistantTableViewCell *cell = (TrafficAssistantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"xgyNewReuseCell"];
        if (cell == nil) {
            cell = [[TrafficAssistantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xgyNewReuseCell"];
        }
        cell.model = _datasoureArray[indexPath.row];
        cell.cellDelgate = self;
        return cell;
    }else{
        TrafficsHistoryTableViewCell *cell = (TrafficsHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"xgyHistoryReuseCell"];
        if (cell == nil) {
            cell = [[TrafficsHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xgyHistoryReuseCell"];
        }
        cell.model = _datasoureArray[indexPath.row];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isNewTask){
        return userinfocellHeight*12 + 30;
    }else{
        return userinfocellHeight*12 ;
    }
   
}

- (void)NewTaskButtonAction:(UIButton *)sender
{
    _isNewTask = true;
    _NewTaskQueryButton.selected = true;
    _HistoryTaskQueryButton.selected = false;
    [self.table.mj_header beginRefreshing];
}

- (void)HistoryTaskButtonAction:(UIButton *)sender
{
    _isNewTask = false;
    _NewTaskQueryButton.selected = false;
    _HistoryTaskQueryButton.selected = true;
     [self.table.mj_header beginRefreshing];
}

- (UIView *)tabbarView
{
    if (_tabbarView == nil) {
        _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, njdScreenHeight - tabarHeight- 64, njdScreenWidth, tabarHeight)];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        
        
        [_tabbarView addSubview:self.HistoryTaskQueryButton];
        [_tabbarView addSubview:self.NewTaskQueryButton];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, njdScreenWidth, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [_tabbarView addSubview:lineView];

        
    }
    return _tabbarView;
}

- (UIButton *)HistoryTaskQueryButton
{
    if (_HistoryTaskQueryButton == nil) {
        _HistoryTaskQueryButton = [[UIButton alloc]initWithFrame:CGRectMake(njdScreenWidth/2, 0, njdScreenWidth/2, tabarHeight)];
        [_HistoryTaskQueryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_HistoryTaskQueryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_HistoryTaskQueryButton setTitle:@"历史任务查询" forState:UIControlStateNormal];
        [_HistoryTaskQueryButton addTarget:self action:@selector(HistoryTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _HistoryTaskQueryButton.selected = !_isNewTask;
    }
    
    return _HistoryTaskQueryButton;
}

- (UIButton *)NewTaskQueryButton
{
    if (_NewTaskQueryButton == nil) {
        _NewTaskQueryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, njdScreenWidth/2, tabarHeight )];
        [_NewTaskQueryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_NewTaskQueryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_NewTaskQueryButton setTitle:@"新任务查询" forState:UIControlStateNormal];
        [_NewTaskQueryButton addTarget:self action:@selector(NewTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _NewTaskQueryButton.selected = _isNewTask;
    }
    
    return _NewTaskQueryButton;
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, njdScreenWidth, njdScreenHeight - 64 -49) style:UITableViewStylePlain];
        _table.delegate  = self;
        _table.dataSource = self;
    }
    return _table;
}


- (void)reloadTrafficData
{
    NJDUserInfoMO *userInfo = [NJDUserInfoMO userInfo];
    NSString *userId = userInfo.userId;
    
    @weakify(self)
    [NetworkingManager getTrafficsDataWithUserId:userId page:_page isNewRecord:_isNewTask success:^(NSDictionary * _Nullable dictValue) {
       @strongify(self)
       NSLog(@"traffic Data %@", dictValue);
       NSArray *dicArray = [dictValue objectForKey:@"residenceList"];
       NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
       NSNumber *isSuccess = checkResult[@"success"];
       if( isSuccess.boolValue ){
           _isLast = false;
           [self.table.mj_footer resetNoMoreData];
           if(_page == 0) {
               _datasoureArray = [NSMutableArray new];
           }
       }else{
           NSString *faildStr = [checkResult objectForKey:@"resultMsg"];
           [NJDPopLoading showMessage:faildStr atView:self.view];
           [self loadFaled];
       }
       
       if (dicArray && dicArray.count > 0) {
           for (int i = 0; i < dicArray.count; i++) {
               NSDictionary *recordList = dicArray[i];
               TrafficAssistantTaskModel *model = [TrafficAssistantTaskModel modelWithDictionary:recordList];
               [_datasoureArray addObject:model];
           }
           [self headerEndfresshViewWithSuccess];
       }else{
           [self loadFaled];
       }
       
    } failure:^(NSError * _Nullable error) {
        if(_page == 0){
            [self headerEndfresshViewWithSuccess];
        }else{
            [self endRefreshViewNoMoreDara];
        }
        [NJDPopLoading showAutoHideWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

- (void)loadFaled
{
    if(_page == 0){
        [self headerEndfresshViewWithSuccess];
    }else{
        [self endRefreshViewNoMoreDara];
    }

}

- (void)endRefreshViewNoMoreDara
{
    _isLast = true;
    [self.table.mj_footer endRefreshingWithNoMoreData];
    [self.table reloadData];
}

- (void)headerEndfresshViewWithSuccess
{
    [self.table.mj_header endRefreshing];
    [self.table reloadData];
}

#pragma mark - Navigation
- (void)trafficActionButtonAction:(NSInteger)index withModel:(TrafficAssistantTaskModel *)model
{
    NSInteger indexNum = index;
    NSString *recordId = model.recordId;
    
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
