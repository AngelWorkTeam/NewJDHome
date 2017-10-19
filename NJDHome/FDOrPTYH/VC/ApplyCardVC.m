//
//  ApplyCardVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/5.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ApplyCardVC.h"
#import "SubmitCell1.h"
#import "SubmitCell3.h"
#import "SubmitCell5.h"
#import "ApplyCardCell1.h"
#import "ApplyCardCell2.h"

#import "IDCardVC.h"
static NSString * const kPostFeeTips  = @"邮费由收件人支付，采用到付方式，邮寄资费按照省内每件15元(人民币)计算";
@interface ApplyCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,copy) NSArray *dataSource;

@property (nonatomic,strong) NSMutableArray *dataImgs;
@property (nonatomic,strong) NSMutableArray *faceImgs;
@property (nonatomic,strong) UIImage *idCardImg;

//上传给后台的地址信息，包括regionId , townId,到村的地址
@property (nonatomic,copy)  NSDictionary *addrDic;
@end

@implementation ApplyCardVC

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
    self.title = @"居住证申办";
    [self createBackNavWithOpaque:YES];
    [self.view addSubview:self.table];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)faceImgs{
    if (!_faceImgs) {
        _faceImgs = [NSMutableArray array];
    }
    return _faceImgs;
}
-(NSMutableArray *)dataImgs{
    if (!_dataImgs) {
        _dataImgs = [NSMutableArray array];
    }
    return _dataImgs;
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
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell3" bundle:nil] forCellReuseIdentifier:@"submitCell3"];
        [_table registerNib:[UINib nibWithNibName:@"SubmitCell5" bundle:nil] forCellReuseIdentifier:@"submitCell5"];
        [_table registerClass:[ApplyCardCell1 class] forCellReuseIdentifier:@"applyCardCell1"];
        [_table registerNib:[UINib nibWithNibName:@"ApplyCardCell2" bundle:nil] forCellReuseIdentifier:@"applyCardCell2"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 0){
        return 85;
    }
    if ( indexPath.section == 2 &&indexPath.row ==0
        && self.dataImgs.count > 0) {
        return 44 + 108;
    }
    if (indexPath.section == 2 && indexPath.row == 1
        && self.faceImgs.count > 0) {
        return 44 + 108;
    }
    NSString *receiveAddr = [self.dataSource[3][0] objectForKey:@"value"];
    if (indexPath.section == 3 &&
        ![receiveAddr isEqualToString:@""]) {
        return 100;
    }
    return 44.;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *receiveAddr = [self.dataSource[3][0] objectForKey:@"value"];
    if (section == 3 && ![receiveAddr isEqualToString:@""]) {
        CGRect rect = [kPostFeeTips boundingRectWithSize:CGSizeMake(kScreenWidth-32, 300)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                 context:nil];
        return rect.size.height;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *receiveAddr = [self.dataSource[3][0] objectForKey:@"value"];
    if (section == 3 && ![receiveAddr isEqualToString:@""]) {
        UILabel *label = [UILabel new];
        label.text = kPostFeeTips;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor sam_colorWithHex:@"888888"];
    
        CGRect rect = [kPostFeeTips boundingRectWithSize:CGSizeMake(kScreenWidth-32, 300)
                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                        context:nil];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, rect.size.height)];
        label.frame = CGRectMake(16, 0, rect.size.width, rect.size.height);
        [view addSubview:label];
        return view;
    }
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
    NSInteger keyboardType = [dic[@"keyboardType"] integerValue];
    if(keyboardType == 1){
        cell.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        cell.keyboardType = UIKeyboardTypeDefault;
    }
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
    if (indexPath.section == 0 && indexPath.row == 0) {
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
    else if(indexPath.section==1 && indexPath.row ==0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"applyCardCell1" forIndexPath:indexPath];
        @weakify(self);
        ((ApplyCardCell1 *)cell).changeAddr = ^(NSString *townId, NSString *regionId, NSString *addr) {
             @strongify(self);
            self.addrDic = @{@"townId":SAFE_STRING(townId),
                             @"regionId":SAFE_STRING(regionId),
                             @"address":SAFE_STRING(addr)
                             };
        };
    }
    else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"submitCell5" forIndexPath:indexPath];
        @weakify(self);
        void (^reloadSection2)(void) = ^{
            @strongify(self);
            NSArray *paths = @[[NSIndexPath indexPathForRow:0 inSection:2],
                               [NSIndexPath indexPathForRow:1 inSection:2]];
            [self.table reloadRowsAtIndexPaths:paths
                              withRowAnimation:UITableViewRowAnimationNone];
            [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
        };
        ((SubmitCell5 *)cell).tookPhoto = ^(UIImage *img) {
            @strongify(self);
            if (img) {
                if (indexPath.row == 0) {
                    [self.dataImgs addObject:img];
                }else{
                    if (self.faceImgs.count==1) {
                        self.faceImgs[0] = img;
                    }else{
                        [self.faceImgs addObject:img];
                    }
                }
                reloadSection2();
            }
        };
        ((SubmitCell5 *)cell).imgs = indexPath.row==0?self.dataImgs:self.faceImgs;
        ((SubmitCell5 *)cell).deleteAllImgs = ^{
            reloadSection2();
        };
    }else if(indexPath.section == 3 && indexPath.row == 0){
         @weakify(self);
        cell = [tableView dequeueReusableCellWithIdentifier:@"applyCardCell2" forIndexPath:indexPath];
        ((ApplyCardCell2 *)cell).shuldShowTextView = ^(BOOL show){
             @strongify(self);
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3];
            [self.table reloadRowsAtIndexPaths:@[path]
                              withRowAnimation:UITableViewRowAnimationNone];
            [self.table reloadData];
            [self.table scrollToRowAtIndexPath:path
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
        };
        NSString *receiveAddr = [self.dataSource[3][0] objectForKey:@"value"];
        if ([receiveAddr isEqualToString:@""]) {
            ((ApplyCardCell2 *)cell).showTextView = NO;
        }else{
            ((ApplyCardCell2 *)cell).showTextView = YES;
        }
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
    if (self.addrDic == nil) {
        [NJDPopLoading showAutoHideWithMessage:@"无法从服务器获取地址,请退出后重试"];
        return;
    }
    
    if (self.idCardImg == nil) {
        [NJDPopLoading showAutoHideWithMessage:@"必须上传身份证照片"];
        return;
    }
    if (self.dataImgs.count == 0) {
        [NJDPopLoading showAutoHideWithMessage:@"必须上传资料照片"];
        return;
    }
    if (self.faceImgs.count == 0) {
       [NJDPopLoading showAutoHideWithMessage:@"必须上传免冠正面照"];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in self.dataSource[0]) {
        params[dic[@"key"]] = dic[@"value"];
    }
    [params addEntriesFromDictionary:self.addrDic];
    NSString *detailAddr = [self.dataSource[1][1] objectForKey:@"value"];
    params[@"address"] = [params[@"address"] stringByAppendingString:detailAddr];
    NSString *receiveAddr = [self.dataSource[3][0] objectForKey:@"value"];
    if ([receiveAddr isEqualToString:@""]) {
        params[@"takeType"] = @0;
    }else{
        params[@"takeType"] = @1;
        params[@"consigneeAddress"] = receiveAddr;
    }
    [NJDPopLoading showMessageWithLoading:@"正在提交"];
    
    [NetworkingManager applyCard:params.copy
                       idCardImg:self.idCardImg
                        dataImgs:self.dataImgs.copy
                         faceImg:self.faceImgs[0]
                         success:^(NSDictionary * _Nullable dictValue) {
                             [NJDPopLoading hideHud];
                             if ([dictValue[@"success"] boolValue] == YES) {
                                 [NJDPopLoading showAutoHideWithMessage:dictValue[@"resultMsg"]];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                         } failure:^(NSError * _Nullable error) {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    NSArray *arr1 = @[@{@"title":@"姓       名",@"key":@"personName",
                        @"value":@"",@"tips":@"必须填写姓名",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"身份证号",@"key":@"personIDCard",
                        @"value":@"",@"tips":@"必须填写身份证号",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"电       话",@"key":@"telephoneNumber",
                        @"value":@"",@"tips":@"必须填手机号码",@"need":@1,
                         @"keyboardType":@"1"
                        }.mutableCopy,
                      @{@"title":@"户籍地址",@"key":@"personAddress",
                        @"value":@"",@"tips":@"必须填写户籍地址",@"need":@1
                        }.mutableCopy,
                      ];
    
    NSArray *arr2 = @[@{@"title":@"所在地区",@"key":@"address",
                        @"value":@"",@"tips":@"必须选择房屋地址",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"详细地址",@"key":@"address",
                        @"value":@"",@"tips":@"必须填写详细地址",@"need":@1
                        }.mutableCopy,
                      ];
    NSArray *arr3 = @[@{@"title":@"资料拍照(必须拍照)",@"key":@"photoImgFiles",
                        @"value":@"",@"need":@1
                        }.mutableCopy,
                      @{@"title":@"人脸拍照(免冠正面照)",@"key":@"faceImgFiles",
                        @"value":@"",@"need":@1
                        }.mutableCopy];
    NSArray *arr4 = @[@{@"title":@"取证方式",@"key":@"takeType",
                        @"value":@"",@"need":@1
                        }.mutableCopy,
                      ];
    
    
    self.dataSource = @[arr1,arr2,arr3,arr4];
    
}
@end
