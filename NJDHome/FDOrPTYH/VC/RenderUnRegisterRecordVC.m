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
#import "MJRefresh.h"
#import "NJDRefreshHeader.h"

@interface RenderUnRegisterRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) NSMutableArray *dateSource;

@property (nonatomic) NSInteger page;
@property (nonatomic) BOOL havePage;

/**
 *  出错信息
 */
@property (nonatomic,copy)NSString *errorMsg;
/**
 * loading中显示文字
 */
@property (nonatomic,copy)NSString *loadingMsg;
@end

@implementation RenderUnRegisterRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initViews];
    
}
-(void)initViews{
    [self createBackNavWithOpaque:YES];
    self.title = @"房客变更注销申报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(pushToUnregisterVC:)];
    [self.view addSubview:self.table];
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
        @weakify(self);
        NJDRefreshHeader *header = [NJDRefreshHeader headerWithRefreshingBlock:^{
             @strongify(self);
            if (self.havePage == NO) {
                [self loadWithPage:1];
            }else{
                [self.table.mj_header endRefreshing];
            }
        }];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header.arrowView.hidden = YES;
        header.activityTintColor = [UIColor sam_colorWithHex:@"5e5e5e"];
        _table.mj_header = header;
        
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
             @strongify(self);
            if (self.havePage) {
                [self loadWithPage:self.page+1];
            }
        }];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.dateSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnRegisterCell" forIndexPath:indexPath];
    cell.name = [self.dateSource[indexPath.section] valueForKeyPath:@"person.name"];
    cell.detailAddr = [self.dateSource[indexPath.section] valueForKey:@"temporaryAddress"];
    cell.roomNum = [self.dateSource[indexPath.section] valueForKey:@"roomNumber"];
    @weakify(self);
    @weakify(indexPath);
    cell.changeBlock = ^{
         @strongify(self);
         @strongify(indexPath);
        [self changeRoomWithIndex:indexPath.section];
    };
    cell.unRegisterBlock = ^{
        @strongify(self);
        @strongify(indexPath);
        [self unRegisterWithIndex:indexPath.section];
    };
    return cell;
}

-(void)initData{
    self.page = 1;
    self.havePage = NO;
    self.dateSource = [NSMutableArray array];
    [[RACObserve(self, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    
    [RACObserve(self, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
    }];
    [self.table.mj_header beginRefreshing];
}

-(void)loadWithPage:(NSInteger)page{
    [NetworkingManager getPersonsRecordWithPage:self.page
                                        success:^(NSArray * _Nullable arrayValue) {
                                            self.loadingMsg = nil;
                                            if (arrayValue.count > 0) {
                                                self.page = page;
                                                self.havePage = YES;
                                                [self.dateSource addObjectsFromArray:arrayValue];
                                                [self.table reloadData];
                                                [self.table.mj_footer endRefreshing];
                                            }else{
                                                self.havePage = NO;
                                                [self.table.mj_footer endRefreshingWithNoMoreData];
                                            }
                                            [self.table.mj_header endRefreshing];
                                        } failure:^(NSError * _Nullable error) {
                                            self.loadingMsg = nil;
                                            self.errorMsg = @"加载失败";
                                            self.errorMsg = nil;
                                            [self.table.mj_header endRefreshing];
                                            [self.table.mj_footer endRefreshing];
                                        }];
}
-(void)changeRoomWithIndex:(NSInteger)index{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改房间号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新的房间号";
    }];
    NSDictionary *dic = self.dateSource[index];
     [alert addAction:[UIAlertAction
                       actionWithTitle:@"确定"
                       style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * _Nonnull action) {
                           NSString *room = [alert.textFields firstObject].text;
                           if (room.length == 0) {
                               return ;
                           }
                           self.loadingMsg = @"正在提交信息";
                           [NetworkingManager
                            changeRecord:SAFE_STRING(dic[@"relativeRecordId"])
                            changeState:2
                            room:SAFE_STRING(room) success:^(NSDictionary * _Nullable dictValue) {
                                self.loadingMsg = nil;
                                self.havePage = NO;
                                [self.dateSource removeAllObjects];
                                [self loadWithPage:1];
                            } failure:^(NSError * _Nullable error) {
                                self.loadingMsg = nil;
                                self.errorMsg = @"操作失败";
                                self.errorMsg = nil;
                            }];
    }]];
     [alert addAction:[UIAlertAction
                       actionWithTitle:@"关闭"
                       style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)unRegisterWithIndex:(NSInteger)index{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"确定注销吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
  
    NSDictionary *dic = self.dateSource[index];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * _Nonnull action) {
                         
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * _Nonnull action) {
                          self.loadingMsg = @"正在提交信息";
                          [NetworkingManager
                           changeRecord:SAFE_STRING(dic[@"relativeRecordId"])
                           changeState:0
                           room:SAFE_STRING(dic[@"roomNumber"]) success:^(NSDictionary * _Nullable dictValue) {
                               self.loadingMsg = nil;
                           } failure:^(NSError * _Nullable error) {
                               self.loadingMsg = nil;
                               self.errorMsg = @"操作失败";
                               self.errorMsg = nil;
                           }];
                      }]];
    [self presentViewController:alert animated:YES completion:nil];

}
@end
