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
#import "TrafficAssistantViewController.h"

#import "TrafficAcceptView.h"
#import "TrafficRejectView.h"
#import "TrafficZhuanjiaoView.h"
#import "UserInfo.h"
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
                                              initWithTitle:@"退出" style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(settingHandle:)];
}

#pragma mark - action handle
-(void)settingHandle:(UIBarButtonItem *)item{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SettingVC *vc =[sb instantiateViewControllerWithIdentifier:@"settingVC"];
//    [self.navigationController pushViewController:vc animated:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确认退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
        [NJDUserInfoMO userInfo].isLogin = NO;
        [NJDUserInfoMO save];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelgate = self;
        return cell;
    }else{
        TrafficsHistoryTableViewCell *cell = (TrafficsHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"xgyHistoryReuseCell"];
        if (cell == nil) {
            cell = [[TrafficsHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xgyHistoryReuseCell"];
        }
        cell.model = _datasoureArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(_isNewTask){
//        return userinfocellHeight*12 + 30;
//    }else{
//        return userinfocellHeight*12 + 30;
//    }
//}

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
         _HistoryTaskQueryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
//        _HistoryTaskQueryButton.backgroundColor = [UIColor yellowColor];
//        _HistoryTaskQueryButton.titleLabel.backgroundColor = [UIColor blueColor];
        
        [_HistoryTaskQueryButton setTitle:@"历史任务查询" forState:UIControlStateNormal];
        [_HistoryTaskQueryButton setImage:[UIImage imageNamed:@"btn_record-query_nor"] forState:UIControlStateNormal];
        [_HistoryTaskQueryButton setImage:[UIImage imageNamed:@"btn_record-query_sel"] forState:UIControlStateSelected];
        [_HistoryTaskQueryButton addTarget:self action:@selector(HistoryTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _HistoryTaskQueryButton.selected = !_isNewTask;
        
        CGRect imageRect = _HistoryTaskQueryButton.imageView.frame;
        CGRect titleRect = _HistoryTaskQueryButton.titleLabel.frame;
        
        //  居中现实
          _HistoryTaskQueryButton.imageEdgeInsets = UIEdgeInsetsMake(-titleRect.size.height, titleRect.size.width - 20, 0, 0);
          _HistoryTaskQueryButton.titleEdgeInsets = UIEdgeInsetsMake(imageRect.size.height, -imageRect.size.width, 0, 0);
        
    }
    
    return _HistoryTaskQueryButton;
}

- (UIButton *)NewTaskQueryButton
{
    if (_NewTaskQueryButton == nil) {
        _NewTaskQueryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, njdScreenWidth/2, tabarHeight )];
        [_NewTaskQueryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_NewTaskQueryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        _NewTaskQueryButton.backgroundColor = [UIColor yellowColor];
//        _NewTaskQueryButton.titleLabel.backgroundColor = [UIColor blueColor];
        [_NewTaskQueryButton setTitle:@"新任务查询" forState:UIControlStateNormal];
        _NewTaskQueryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_NewTaskQueryButton setImage:[UIImage imageNamed:@"btn_task-query_nor"] forState:UIControlStateNormal];
        [_NewTaskQueryButton setImage:[UIImage imageNamed:@"btn_task-query_sel"] forState:UIControlStateSelected];
        [_NewTaskQueryButton addTarget:self action:@selector(NewTaskButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _NewTaskQueryButton.selected = _isNewTask;
        
        CGRect imageRect = _NewTaskQueryButton.imageView.frame;
        CGRect titleRect = _NewTaskQueryButton.titleLabel.frame;
        
        //  居中现实
        _NewTaskQueryButton.imageEdgeInsets = UIEdgeInsetsMake(-titleRect.size.height, titleRect.size.width - 19 , 0, 0);
        _NewTaskQueryButton.titleEdgeInsets = UIEdgeInsetsMake(imageRect.size.height, -imageRect.size.width, 0, 0);
        
    }
    
    return _NewTaskQueryButton;
}

- (UITableView *)table
{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, njdScreenWidth, njdScreenHeight - 64 -49) style:UITableViewStylePlain];
        _table.delegate  = self;
        _table.dataSource = self;
        _table.estimatedRowHeight = userinfocellHeight*12;
        _table.rowHeight = UITableViewAutomaticDimension;
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
    if([model.state isEqualToString:@"1"]){
        if (index == 0) {
            [self showTrafficAcceptAction:model];
        }else if(index == 1){
            [self showTrafficRejectAction:model];
        }else if(index == 2){
            [self showTrafficZhuanjiaoAction:model];
        }
    }else if([model.state isEqualToString:@"2"]){
        
        [self showbiangengzhuxiaoshengbaoAction:model];
//        if([model.type isEqualToString:@"0"]){ // // 注销登记
//        }else if ([model.type isEqualToString:@"1"]){  //// 申报登记
//        }else if ([model.type isEqualToString:@"2"]){    // 变更登记
//        }
    }
}

- (void)showbiangengzhuxiaoshengbaoAction:(TrafficAssistantTaskModel *)model
{
    TrafficRejectView *view = [TrafficRejectView new];
    view.title = @"完成登记";
    
    view.model = model;
    view.rejectReasonArray  = [NSMutableArray arrayWithObjects:@"无任何记录人员新登记",@"有历史记录但现在不在册人员新登记",@"现在在册记录重新登记", nil];
    view.tuihuiyuanyinTitle.text = @"完成情况:";
    view.qitayuanyinTitle.text = @"完成说明:";
    [view.acceptButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    @weakify(self);
    view.TrafficRejectAction  = ^(NSString *reason, NSString *userSuggest){
        @strongify(self);
        [self TrafficShenbaoDengjiactionWithReason:reason note:userSuggest model:model];
    };
}

- (void)showTrafficAcceptAction:(TrafficAssistantTaskModel *)model
{
    TrafficAcceptView *view = [TrafficAcceptView new];
    view.title = @"受理";
    view.model = model;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    @weakify(self)
    view.TraffiAcceptAction = ^(NSString *checkdate, NSString *checkTime, NSString *userSuggest) {
        @strongify(self)
        [self TrafficAcceptActionTimer:checkdate time:checkTime andSuggest:userSuggest model:model] ;
    };
}

- (void)showTrafficRejectAction:(TrafficAssistantTaskModel *)model
{
    TrafficRejectView *view = [TrafficRejectView new];
    view.title = @"退回";
    view.model = model;
    view.rejectReasonArray  = [NSMutableArray arrayWithObjects:@"本地户口无需登记",@"信息不完整",@"无法联系到本人",@"已经登记且有效期1月以上无需重复登记", nil];

    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    @weakify(self);
    view.TrafficRejectAction  = ^(NSString *reason, NSString *userSuggest){
        @strongify(self);
        [self TrafficRejectActionWithReason:reason andsuggest:userSuggest model:model];
    };
}

- (void)showTrafficZhuanjiaoAction:(TrafficAssistantTaskModel *)model
{
    TrafficZhuanjiaoView *view = [TrafficZhuanjiaoView new];
    view.title = @"转交";
    view.model = model;
     [self.view addSubview:view];
    
    [self getRegionXGYWithModel:model WithSuccessBlock:^(NSDictionary * _Nullable dictValue) {
        NSLog(@"dictValue: %@",dictValue);
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            NSMutableArray *xgyArray =  [NSMutableArray new];
           NSArray *guards = dictValue[@"guards"];
            for (int i = 0; i < guards.count; i++) {
                NSDictionary *personInfo = guards[i];
                NSDictionary *userinfos = personInfo[@"user"];
                
               UserInfo *modelValue = [UserInfo modelWithDictionary:userinfos];
                [xgyArray addObject:modelValue];
            }
                view.xgyArray = xgyArray;
        }else{
            NSString *successInfo = @"获取协管员失败";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }
    
       
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    view.zhuanjiaoAction = ^( UserInfo *modelValue) {
        NSString *changedUserId = modelValue.userId;
        [self TrafficZhuanjiaoActionWithUserName:changedUserId model:model];
    };
}


- (void)TrafficAcceptActionTimer:(NSString *)checkDate time:(NSString *)checkTime andSuggest:(NSString *)suggest model:(TrafficAssistantTaskModel *)model
{
    NSString *recordId = model.recordId;
    
    [NetworkingManager trafficAcceptTheRecordWithRecordId:recordId
                                                checkDate:(NSString *)checkDate
                                                checkTime:(NSString *)checkTime
                                                     note:suggest
                                                  success:^(NSDictionary * _Nullable dictValue) {
                                                         NSLog(@"callback message %@", dictValue);
//                                                      {
//                                                          accessResult =     {
//                                                              resultMsg = "\U53d7\U7406\U6210\U529f";
//                                                              success = 1;
//                                                          };
//                                                          checkResult =     {
//                                                              resultMsg = "\U64cd\U4f5c\U4ee4\U724c\U6b63\U786e";
//                                                              success = 1;
//                                                          };
//                                                      }
                                                      NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
                                                      NSNumber *isSuccess = checkResult[@"success"];
                                                      if( isSuccess.boolValue ){
                                                          NSString *successInfo = @"成功";
                                                          [NJDPopLoading showAutoHideWithMessage:successInfo];
                                                      }else {
                                                          NSString *successInfo = @"失败";
                                                          [NJDPopLoading showAutoHideWithMessage:successInfo];
                                                      }
                                                         
                                                         [self reloadTrafficData];
                                                     } failure:^(NSError * _Nullable error) {
                                                          NSString *errorMsg = error.userInfo[NSLocalizedDescriptionKey];
                                                          [NJDPopLoading showAutoHideWithMessage:errorMsg];
                                                     }];
}

- (void)TrafficRejectActionWithReason:(NSString *)reason andsuggest:(NSString *)sugges model:(TrafficAssistantTaskModel *)model
{
    NSString *recordId = model.recordId;
    [NetworkingManager  trafficSendBackRecordTheRecordWithRecordId:recordId sendBckContext:reason qtContext:sugges success:^(NSDictionary * _Nullable dictValue) {
        
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            NSString *successInfo = @"成功";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }else {
            NSString *successInfo = @"失败";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }
        
    } failure:^(NSError * _Nullable error) {
        NSString *errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
}

- (void)TrafficZhuanjiaoActionWithUserName:(NSString *)name model:(TrafficAssistantTaskModel *)model
{
    NSString *recordId = model.recordId;
    NSString *changeidUserId = @"";
    [NetworkingManager trafficCareOfRecordTheRecordWithRecordId:recordId changeUserId:(NSString *)changeidUserId success:^(NSDictionary * _Nullable dictValue) {
        
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            NSString *successInfo = @"成功";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }else {
            NSString *successInfo = @"失败";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }
        
    } failure:^(NSError * _Nullable error) {
        NSString *errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    
}

- (void)TrafficShenbaoDengjiactionWithReason:(NSString *)reason note:(NSString *)note model:(TrafficAssistantTaskModel *)model
{
     NSString *recordId = model.recordId;

    [NetworkingManager trafficRegisterRecordTheRecordWithRecordId:recordId personTypeName:reason note:note success:^(NSDictionary * _Nullable dictValue) {
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            NSString *successInfo = @"成功";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }else {
            NSString *successInfo = @"失败";
            [NJDPopLoading showAutoHideWithMessage:successInfo];
        }
    } failure:^(NSError * _Nullable error) {
        NSString *errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
}

- (void)getRegionXGYWithModel:(TrafficAssistantTaskModel *)model WithSuccessBlock:(void(^)(NSDictionary * _Nullable dictValue))successblock
{
    NSString *regionId = model.regionId;
    [NetworkingManager GetRegionXGYSBayRegionId:regionId success:^(NSDictionary * _Nullable dictValue) {
        successblock(dictValue);
        
    } failure:^(NSError * _Nullable error) {
      
        [NJDPopLoading showAutoHideWithMessage:@"获取协管员名单失败"];
    }];
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
