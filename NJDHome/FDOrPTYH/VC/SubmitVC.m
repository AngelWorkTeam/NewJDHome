//
//  SubmitVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitVC.h"
#import "SubmitCell1.h"
#import "SubmitCell2.h"
#import "SubmitCell3.h"
#import "SubmitCell4.h"
#import "SubmitCell5.h"
#import "ChilderSubmitView.h"
#import "IDCardVC.h"
@interface SubmitVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,copy) NSArray *dataSource;

//房东为租客填写时，房屋地址为房东已经录入的房屋地址
@property (nonatomic,copy) NSArray *addr;
//身份证照片
@property (nonatomic,copy) UIImage *idCardImg;
//随同人员数组
@property (nonatomic,strong) NSMutableArray *childInfos;
//租客的照片数组
@property (nonatomic,strong) NSMutableArray *renterImgs;
@end

@implementation SubmitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDatas];
    [self initViews];
}
-(void)initViews{
    [self createBackNavWithOpaque:YES];
    [self.view addSubview:self.table];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createBackNavWithOpaque:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setType:(SubmitType)type{
    _type = type;
    switch (type) {
        case SubmitTypeOwn:
            self.title = @"本人申报";
            break;
        case SubmitTypeOther:
            self.title = @"他人申报";
            break;
        case SubmitTypeRenter:
            self.title = @"房客登记";
            break;
        default:
            break;
    }
}
#pragma mark - get set method
-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170/2)];
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
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell4" bundle:nil] forCellReuseIdentifier:@"submitCell4"];
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell5" bundle:nil] forCellReuseIdentifier:@"submitCell5"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}
-(NSMutableArray *)childInfos{
    if(!_childInfos){
        _childInfos = [NSMutableArray array];
    }
    return _childInfos;
}
-(NSMutableArray *)renterImgs{
    if(!_renterImgs){
        _renterImgs = [NSMutableArray array];
    }
    return _renterImgs;
}
#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section == 2 && self.childInfos.count > 0) {
        return 44 + 90*self.childInfos.count + 10;
    }
    if (indexPath.section == 3 && self.renterImgs.count > 0) {
        return 44 + 108;
    }
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

#pragma mark -private method
-(SubmitCell *)getCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubmitCell *cell;
    @weakify(tableView);
    void (^dismissKeyboard)(void) = ^{
        @strongify(tableView);
        [tableView endEditing:YES];
    };
    __weak typeof (self) weakSelf = self;
    if (indexPath.section == 0 &&
        (indexPath.row == 0)) {
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
    }else if((indexPath.section == 0 &&
             (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 7))
             ||(indexPath.section == 1 && (indexPath.row < 3 || indexPath.row == 4))){
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell2" forIndexPath:indexPath];
        cell.shouldDismissKeyboard = dismissKeyboard;
        [self prepareForCell2PickDataSourceWithCell:(SubmitCell2 *)cell path:indexPath];
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell4" forIndexPath:indexPath];
        @weakify(self);
        ((SubmitCell4 *)cell).addChildInfo = ^{
             @strongify(self);
            if (self.childInfos.count >= 2) {
                return ;
            }
            [self.childInfos addObject:@{@"childName":@"",
                                         @"childSex":@"男",
                                         @"childBirth":[[NSDate date] LocalDayISO8601String]
                                         }];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            [self.table scrollToRowAtIndexPath:path
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        };
        ((SubmitCell4 *)cell).minsChildInfo = ^{
            @strongify(self);
            if (self.childInfos.count > 0) {
                [self.childInfos removeLastObject];
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
                [self.table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                [self.table scrollToRowAtIndexPath:path
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        };
        NSMutableArray *shouldRemoveViews = [NSMutableArray array];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[ChilderSubmitView class]]) {
                [shouldRemoveViews addObject:view];
            }
        }
        for (UIView *view in shouldRemoveViews) {
            [view removeFromSuperview];
        }
        for (int i = 0; i < self.childInfos.count; i++) {
            NSDictionary *dic = self.childInfos[i];
            ChilderSubmitView *child = [ChilderSubmitView new];
            child.frame = CGRectMake(16, 44+i*90, kScreenWidth-32, 90);
            [cell.contentView addSubview:child];
            child.childInfo = dic;
            child.changeChildInfo = ^(NSDictionary *dic){
                 @strongify(self);
                self.childInfos[i] = dic;
            };
        }
    }else if(indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell5" forIndexPath:indexPath];
        @weakify(self);
        void (^reloadSection3)(void) = ^{
             @strongify(self);
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3];
            [self.table reloadRowsAtIndexPaths:@[path]
                              withRowAnimation:UITableViewRowAnimationNone];
            [self.table scrollToRowAtIndexPath:path
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
        };
        ((SubmitCell5 *)cell).tookPhoto = ^(UIImage *img) {
             @strongify(self);
            if (img) {
                [self.renterImgs addObject:img];
                reloadSection3();
            }
            
        };
        ((SubmitCell5 *)cell).imgs = self.renterImgs;
        ((SubmitCell5 *)cell).deleteAllImgs = ^{
            reloadSection3();
        };
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
        if (path.row == 6) {
            cell.pickType = PickTypeDate;
            cell.dataSource = nil;
            return;
        }
        if (path.row == 7 && [NJDUserInfoMO roleType] == BNRRoleTypeLandlord){
            cell.pickType = PickTypeCustom;
            cell.dataSource = self.addr;
            return;
        }
        if (path.row == 7) {
            cell.pickType = PickTypeAddr;
            cell.dataSource = nil;
            return;
        }
    }
    if (path.section == 1) {
        cell.pickType = PickTypeCustom;
        if (path.row == 0) {
             cell.dataSource = @[@"初中",@"高中",@"技工学校",@"中专中技",
                                 @"大专",@"大学本科",@"研究生",@"博士",@"小学"];
        }else if(path.row ==1){
            cell.dataSource = @[@"群众",@"共青团员",@"党员"];
        }else if(path.row ==2){
            cell.dataSource = @[@"无神论",@"天主教",@"基督教",@"基督教",@"佛教",
                                @"伊斯兰教",@"道教",@"犹太教",@"印度教"];
        }else if(path.row == 4){
            cell.dataSource = @[@"初级",@"中级",@"高级"];
        }
    }
}
-(void)comfirmHandle:(UIButton *)btn{
    
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
#pragma mark - sever interface
-(void)idtifierIdWithImg:(UIImage *)img{
    [NJDPopLoading showMessageWithLoading:@"正在识别你的信息"];
    [NetworkingManager identifierIdWithImg:img
                                   success:^(NSArray * _Nullable arrayValue) {
                                       [NJDPopLoading hideHud];
                                       NSDictionary *dic = [arrayValue firstObject];
                                       NSMutableDictionary *sourceDic = self.dataSource[0][0];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"name"]);
                                       sourceDic = self.dataSource[0][1];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"gender"]);
                                       sourceDic = self.dataSource[0][2];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"race"]);
                                       sourceDic = self.dataSource[0][3];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"id_card_number"]);
                                       sourceDic = self.dataSource[0][4];
                                       sourceDic[@"value"] = SAFE_STRING(dic[@"address"]);
                                     self.idCardImg = img;
                                       [self.table reloadData];
                                   } failure:^(NSError * _Nullable error) {
                                       [NJDPopLoading hideHud];
                                       [NJDPopLoading showAutoHideWithMessage:@"无法识别，请重试"];
                                   }];
}
-(void)initDatas{
    if ([NJDUserInfoMO roleType] == BNRRoleTypeLandlord) {
        [NetworkingManager getLandLordAddressSuccess:^(NSArray * _Nullable arrayValue) {
            if (arrayValue.count == 0) {
                [NJDPopLoading showAutoHideWithMessage:@"请现在房屋地址管理中新增地址"];
                return ;
            }
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:arrayValue.count];
            for (NSDictionary *dic in arrayValue) {
                [arr addObject:SAFE_STRING(dic[@"address"])];
            }
            self.addr = arr.copy;
            if (self.dataSource.count > 0 &&
                ((NSArray *)self.dataSource[0]).count > 7) {
                NSMutableDictionary *dic = self.dataSource[0][7];
                dic[@"value"] = [self.addr firstObject];
                [self.table reloadRowsAtIndexPaths:
                             @[[NSIndexPath indexPathForRow:7 inSection:0]]
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
                        @"value":@"男",@"tips":@"必须选择性别",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"民       族",@"key":@"nation",
                        @"value":@"汉",@"tips":@"必须填写民族",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"身份证号",@"key":@"personIDCard",
                        @"value":@"",@"tips":@"必须填写身份证号",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"户口地址",@"key":@"personAddress",
                        @"value":@"",@"tips":@"必须填写户籍地址",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"工作单位",@"key":@"companyName",
                        @"value":@"",@"need":@0
                        }.mutableCopy,
                      @{@"title":@"入住时间",@"key":@"enterDate",
                        @"value":[[NSDate date] LocalDayISO8601String],@"need":@0
                        }.mutableCopy,
                      @{@"title":@"房屋地址",@"key":@"temporaryAddress",
                        @"value":@"",@"tips":@"必须选择房屋地址",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"房间号码",@"key":@"roomNumber",
                        @"value":@"",@"tips":@"必须填写房间号",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"电       话",@"key":@"personPhone",
                        @"value":@"",@"tips":@"必须填手机号码",@"need":@1
                        }.mutableCopy
                      ];
    
    NSArray *arr2 = @[@{@"title":@"文化程度",@"key":@"education",
                        @"value":@"初中",@"tips":@"必须选择文化程度",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"政治面貌",@"key":@"politicsState",
                        @"value":@"群众",@"tips":@"必须选择政治面貌",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"宗教信仰",@"key":@"faith",
                        @"value":@"无神论",@"tips":@"必须选择信仰",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"职       业",@"key":@"profession",
                        @"value":@"",@"need":@0
                        }.mutableCopy,
                      @{@"title":@"职业技术等级",@"key":@"jobTitleGrade",
                        @"value":@"初级",@"tips":@"必须选择职业技术等级",@"need":@1
                        }.mutableCopy,
                      ];
    NSArray *arr3 = @[@{@"title":@"随同(未满16周岁)的人员",@"key":@"children",
                        @"value":@"",@"need":@0
                        }.mutableCopy];
    NSArray *arr4 = @[@{@"title":@"租客拍照(必须拍照)",@"key":@"photoImgFiles",
                        @"value":@"",@"need":@1
                        }.mutableCopy];
    
    if (self.type == SubmitTypeRenter) {
        self.dataSource = @[arr1,arr2,arr3,arr4];
    }else{
        NSArray *arr5 = @[@{@"title":@"房主姓名",@"key":@"landlordName",
                            @"value":@"",@"need":@0
                            }.mutableCopy,
                          @{@"title":@"身份证号",@"key":@"landlordIDCard",
                            @"value":@"",@"need":@0
                            }.mutableCopy,
                          @{@"title":@"房主电话",@"key":@"landlordPhone",
                            @"value":@"",@"need":@0
                            }.mutableCopy,];

        self.dataSource = @[arr1,arr2,arr3,arr4,arr5];
    }
    
}
@end
