//
//  WindowClerkViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "WindowClerkViewController.h"
#import "SettingVC.h"
#import "TrafficAssistantTableViewCell.h"
#import "TrafficsHistoryTableViewCell.h"
#import "TrafficAssistantTaskModel.h"
#import "NetworkingManager+YYNetRequest.h"
#import <MJRefresh.h>
#import "NJDRefreshHeader.h"
#import "TrafficAssistantViewController.h"
#import "WindowClerkTableViewCell.h"
#import "WindowClerkHistoryTableViewCell.h"
#import "WindowClerkCellModel.h"
#import "ViewImageModel.h"
#import "MWPhotoBrowser.h"
#import "WindowRejectReasonView.h"
@interface WindowClerkViewController ()<UITableViewDelegate, UITableViewDataSource,WindowClerkTableViewCellDelegate,WindowClerkHistoryTableViewCellDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIView   *tabbarView;

@property (nonatomic, strong) UIButton *NewTaskQueryButton;

@property (nonatomic, strong) UIButton *HistoryTaskQueryButton;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *datasoureArray;

@property (nonatomic, assign) BOOL isNewTask;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL  isLast;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSString       *selectRecordId;
@property (nonatomic, strong) NSString       *selectType;
@end
#define tabarHeight 49
@implementation WindowClerkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _datasoureArray = [NSMutableArray new];
    _photoArray = [NSMutableArray new];
    _isNewTask = true;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self initViews];
    
    
    [self.view addSubview:self.table];
    
    [self.view addSubview:self.tabbarView];
    
    _page = 1;
    _isLast = false;
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
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
   // return 1;
    return _datasoureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isNewTask) {
        WindowClerkTableViewCell *cell = (WindowClerkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"windowNewReuseCell"];
        if (cell == nil) {
            cell = [[WindowClerkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"windowNewReuseCell"];
        }
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _datasoureArray[indexPath.row];
        return cell;
    }else{
        WindowClerkHistoryTableViewCell *cell = (WindowClerkHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"xgyHistoryReuseCell"];
        if (cell == nil) {
            cell = [[WindowClerkHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xgyHistoryReuseCell"];
        }
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _datasoureArray[indexPath.row];
        //_datasoureArray[indexPath.row];
        return cell;
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(_isNewTask){
//        return windowclekcellHeight*9 + 30;
//    }else{
//        return windowclekcellHeight*9 + 30;
//    }
//
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
        _table.estimatedRowHeight = windowclekcellHeight*11;
        _table.rowHeight = UITableViewAutomaticDimension;
    }
    return _table;
}

- (void)reloadDataFromPageZero
{
    _page = 1;
    [self.table.mj_header beginRefreshing];
}

- (void)reloadTrafficData
{
    NJDUserInfoMO *userInfo = [NJDUserInfoMO userInfo];
    NSString *userId = userInfo.userId;
    
    @weakify(self)
    [NetworkingManager getWindowsClerkDataWithUserId:userId page:_page isNewRecord:_isNewTask success:^(NSDictionary * _Nullable dictValue) {
        @strongify(self)
        NSLog(@"traffic Data %@", dictValue);
        NSArray *dicArray = [dictValue objectForKey:@"residenceList"];
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            _isLast = false;
            [self.table.mj_footer resetNoMoreData];
            if(_page == 1) {
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
                WindowClerkCellModel *model = [WindowClerkCellModel modelWithDictionary:recordList];
                [_datasoureArray addObject:model];
            }
            [self headerEndfresshViewWithSuccess];
        }else{
            [self loadFaled];
        }
        
    } failure:^(NSError * _Nullable error) {
        if(_page == 1){
            [self headerEndfresshViewWithSuccess];
        }else{
            [self endRefreshViewNoMoreDara];
        }
        [NJDPopLoading showAutoHideWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
    }];
}

- (void)loadFaled
{
    if(_page == 1){
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

#pragma mark - WindowClerkTableViewCellDelegate
- (void)windowClerkButtonAction:(NSInteger)index withModel:(WindowClerkCellModel *)model
{
   
    [self showImageWithIndex:index model:model];
}

- (void)windowClerkOperationAction:(NSInteger)index withModel:(WindowClerkCellModel *)model
{
    NSString *modelState = model.state;
    NSString *recordId = model.recordId;
    NSLog(@"state %@ index %d", modelState, index);
    if ([model.state isEqualToString:@"0"]) {
        if (index == 0) { // 受理
            [self showBanliwancActionWithTitle:@"确认要受理?" okAction:^(UIAlertAction *action) {
                 [self windwonClerkAcceptWithRecordId:recordId state:@"1" reason:@""];
            }];
        }else if(index == 1){ // 退回
            [self showReasonViewWintRecordId:recordId state:@"-1"];
        }
    }else if([model.state isEqualToString:@"1"]){
       // 办理完成
        [self showBanliwancActionWithTitle:@"确认办理完成?" okAction:^(UIAlertAction *action) {
            [self windwonClerkAcceptWithRecordId:recordId state:@"2" reason:@""];
        }];
    }
    
}
#pragma mark - WindowClerkHistoryTableViewCellDelegate


- (void)windowClerkHistoryButtonAction:(NSInteger)index withModel:(WindowClerkCellModel *)model
{
    NSLog(@"index: %ld", (long)index);
    [self showImageWithIndex:index model:model];
}

- (void)showImageWithIndex:(NSInteger )index model:(WindowClerkCellModel *)model
{
    
    NSArray *picArray = @[];
    if(index == 0){  // 资料照片
        picArray =  model.didPigPaths;
    }else if(index == 1){  // 身份证照片
        picArray = model.idCardPigPaths;
    }else if(index == 2){  // 人脸照片
        picArray = model.facePigPaths;
    }
    NSLog(@"index: %ld count:%d", (long)index, picArray.count);
    NSString *recorid = model.recordId;
    NSString *type = @"0";
    if (index == 1) {
        type = @"1";
    }
    _selectRecordId = recorid;
    _selectType  = type;
    _photoArray = [[NSMutableArray alloc]initWithArray:picArray];
    
    if(picArray.count > 0){
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = false;
        //设置当前要显示的图片
        [browser setCurrentPhotoIndex:1];
        [self.navigationController pushViewController:browser animated:true];
    }

}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photoArray.count;
    
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    NSString *str =[_photoArray objectAtIndex:index];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",windwonImageBasePath,str];
 
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:pathStr]];
    return photo;
}

- (void)showBanliwancActionWithTitle:(NSString *)title okAction:(void (^ __nullable)(UIAlertAction *action))okAction
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakAlert = alert;
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确认"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          okAction(action);
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           [weakAlert dismissViewControllerAnimated:YES completion:nil];
                      }]];
     [self presentViewController:alert animated:YES completion:nil];
}

- (void)showReasonViewWintRecordId:(NSString *)recordId state:(NSString *)state
{
    WindowRejectReasonView *reasonView =  [[WindowRejectReasonView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:reasonView];
    [reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    reasonView.windrejectReasonAction = ^(NSString *reason) {
        NSString *reasonStr = reason;
        NSLog(@"reason %@", reasonStr);
        [self windwonClerkAcceptWithRecordId:recordId state:state reason:reasonStr];
    };
}

- (void)windwonClerkAcceptWithRecordId:(NSString *)recordId state:(NSString *)state reason:(NSString *)reason
{
    [NetworkingManager windowAcceptAndRejectWithRecordId:recordId state:state reason:reason success:^(NSDictionary * _Nullable dictValue) {
        NSDictionary *checkResult = [dictValue objectForKey:@"checkResult"];
        NSNumber *isSuccess = checkResult[@"success"];
        if( isSuccess.boolValue ){
            [NJDPopLoading showAutoHideWithMessage:@"成功"];
            [self reloadDataFromPageZero];
        }else{
            [NJDPopLoading showAutoHideWithMessage:@"操作失败"];
        }
    } failure:^(NSError * _Nullable error) {
         [NJDPopLoading showAutoHideWithMessage:@"操作失败"];
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
