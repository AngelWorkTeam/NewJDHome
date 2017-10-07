//
//  UnregisterVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/7.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "UnregisterVC.h"
#import "SubmitCell.h"
#import "SubmitCell1.h"
#import "SubmitCell2.h"
#import "SubmitCell3.h"
#import "IDCardVC.h"
@interface UnregisterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) UITableView *table;
@property (nonatomic,copy)  UIImage *idCardImg;
@property (nonatomic,copy) NSArray *landLordAddrs;
@property (nonatomic,copy)  NSArray *dataSource;
@end

@implementation UnregisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDatas];
    [self initViews];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createBackNavWithOpaque:YES];
}
-(void)initViews{
    self.title = @"注销申报";
    [self createBackNavWithOpaque:YES];
    [self.view addSubview:self.table];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
        UIButton *comfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [comfirm setTitle:@"确定" forState:UIControlStateNormal];
        comfirm.titleLabel.textColor = [UIColor whiteColor];
        comfirm.backgroundColor = [UIColor redColor];
        comfirm.layer.masksToBounds = YES;
        comfirm.layer.cornerRadius = 5.;
        [_table.tableFooterView addSubview:comfirm];
        [comfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@16);
            make.trailing.bottom.equalTo(@-16);
        }];
        [comfirm addTarget:self action:@selector(comfirmHandle:) forControlEvents:UIControlEventTouchUpInside];
        _table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell1" bundle:nil] forCellReuseIdentifier:@"submitCell1"];
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell2" bundle:nil] forCellReuseIdentifier:@"submitCell2"];
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell3" bundle:nil] forCellReuseIdentifier:@"submitCell3"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 44.;
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
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.dataSource[section];
    return rows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubmitCell *cell = [self getCell:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
    @weakify(self);
    cell.didChangeValue = ^(id value){
        @strongify(self);
        NSMutableDictionary *dic = self.dataSource[indexPath.section][indexPath.row];
        if(value != nil){
            dic[@"value"] = value;
        }
    };
    cell.title = dic[@"title"];
    cell.contentStr = dic[@"value"];
    cell.placeHolder = [dic[@"need"] boolValue] == YES?@"必填":@"选填";
    return cell;
}
-(SubmitCell *)getCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubmitCell *cell;
    @weakify(tableView);
    void (^dismissKeyboard)(void) = ^{
        @strongify(tableView);
        [tableView endEditing:YES];
    };
    __weak typeof (self) weakSelf = self;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell1" forIndexPath:indexPath];
        cell.shouldDismissKeyboard = dismissKeyboard;
        ((SubmitCell1 *)cell).pushToTakeIdCard = ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            IDCardVC *vc = [sb instantiateViewControllerWithIdentifier:@"IDCardVC"];
            vc.idCardImg = ^(UIImage *img){
                [weakSelf idtifierIdWithImg:img];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    else if(indexPath.row == 1 || indexPath.row == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell2" forIndexPath:indexPath];
        cell.shouldDismissKeyboard = dismissKeyboard;
        [self prepareForCell2PickDataSourceWithCell:(SubmitCell2 *)cell path:indexPath];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell3" forIndexPath:indexPath];
        cell.shouldLoacteMiddle = ^{
            @strongify(tableView);
            [tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:YES];
        };
    }
    
    return cell;
}
-(void)prepareForCell2PickDataSourceWithCell:(SubmitCell2 *)cell path:(NSIndexPath *)path{
    if (path.section == 0) {
        if (path.row == 1) {
            cell.pickType = PickTypeCustom;
            cell.dataSource = @[@"男",@"女"];
            return;
        }
        if (path.row == 4 && [NJDUserInfoMO roleType] == BNRRoleTypeLandlord){
            cell.pickType = PickTypeCustom;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.landLordAddrs.count];
            for (NSDictionary *dic in self.landLordAddrs) {
                [arr addObject:SAFE_STRING(dic[@"address"])];
            }
            cell.dataSource = arr.copy;
            return;
        }
    }
}
-(void)idtifierIdWithImg:(UIImage *)img{
    [NJDPopLoading showMessageWithLoading:@"正在识别你的信息"];
    [NetworkingManager identifierIdWithImg:img
                                   success:^(NSArray * _Nullable arrayValue) {
                                       [NJDPopLoading hideHud];
                                       NSDictionary *dic = [arrayValue firstObject];
                                       NSMutableDictionary *sourceDic = self.dataSource[0][0];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"name"]);
                                       sourceDic = self.dataSource[0][1];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"id_card_number"]);
                                       sourceDic = self.dataSource[0][3];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"address"]);
                                       self.idCardImg = img;
                                       [self.table reloadData];
                                   } failure:^(NSError * _Nullable error) {
                                       [NJDPopLoading hideHud];
                                       [NJDPopLoading showAutoHideWithMessage:@"无法识别，请重试"];
                                   }];
}

-(void)comfirmHandle:(UIButton *)btn{
    [self.table endEditing:YES];
    //验证参数
    BOOL (^vildateParam)(NSArray *arr) = ^(NSArray *arr){
        for (NSDictionary *dic in arr) {
            if ([dic[@"need"] boolValue] == YES && [dic[@"value"] isEqualToString:@""]) {
                [NJDPopLoading showAutoHideWithMessage:dic[@"tips"]];
                return NO;
            }
        }
        return YES;
    };
    if (vildateParam(self.dataSource[0]) == NO) {
        return;
    }
   
    if (self.idCardImg == nil) {
        [NJDPopLoading showAutoHideWithMessage:@"必须上传身份证照片"];
        return;
    }
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in self.dataSource[0]) {
        params[dic[@"key"]] = dic[@"value"];
    }
   
    [NJDPopLoading showMessageWithLoading:@"正在提交"];
    [NetworkingManager unRegisterRender:params.copy
                              idCardImg:self.idCardImg
                                success:^(NSDictionary * _Nullable dictValue) {
                                    [NJDPopLoading hideHud];
                                    if ([dictValue[@"success"] boolValue] == YES) {
                                        [NJDPopLoading showAutoHideWithMessage:dictValue[@"resultMsg"]];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }
                                failure:^(NSError * _Nullable error) {
                                    [NJDPopLoading hideHud];
                                    [NJDPopLoading showAutoHideWithMessage:error.userInfo[NSLocalizedDescriptionKey]];
                                }];
}
#pragma mark - noti
-(void)keyboardShow:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.table.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-keyboardRect.size.height-20);
}
-(void)keyboardDismiss:(NSNotification *)noti{
    self.table.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
}
-(void)initDatas{
    if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
        [NetworkingManager getLandLordAddressSuccess:^(NSArray * _Nullable arrayValue) {
            if (arrayValue.count == 0) {
                [NJDPopLoading showAutoHideWithMessage:@"请现在房屋地址管理中新增地址"];
                return ;
            }
            self.landLordAddrs = arrayValue;
            if (self.dataSource.count > 0 &&
                ((NSArray *)self.dataSource[0]).count > 3) {
                NSMutableDictionary *dic = self.dataSource[0][4];
                NSDictionary *addrDic = [self.landLordAddrs firstObject];
                dic[@"value"] = SAFE_STRING(addrDic[@"address"]);
                [self.table reloadRowsAtIndexPaths:
                 @[[NSIndexPath indexPathForRow:4 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        } failure:^(NSError * _Nullable error) {
            [NJDPopLoading showAutoHideWithMessage:@"无法获取您的房屋地址"];
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    NSArray *arr1 = @[@{@"title":@"姓       名",@"key":@"personName",
                        @"value":@"",@"tips":@"必须填写姓名",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"性       别",@"key":@"sex",
                        @"value":@"",@"tips":@"必须选择性别",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"房间号码",@"key":@"roomNumber",
                        @"value":@"",@"tips":@"必须填房间号",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"身份证号",@"key":@"personIDCard",
                        @"value":@"",@"tips":@"必须填写身份证号",@"need":@1
                        }.mutableCopy,
                      
                      @{@"title":@"房屋地址",@"key":@"temporaryAddress",
                        @"value":@"",@"tips":@"必须选择房屋地址",@"need":@1
                        }.mutableCopy,
                      ];

    self.dataSource = @[arr1];
    
}
@end

