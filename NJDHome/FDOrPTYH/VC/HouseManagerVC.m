//
//  HouseManagerVC.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "HouseManagerVC.h"
#import "AddAddressView.h"
#import "AddressSelectView.h"
@interface HouseCell:UITableViewCell

@end

@implementation HouseCell
-(void)layoutSubviews{
    [super layoutSubviews];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end

@interface HouseManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSArray *dataSource;


@property (nonatomic,copy)NSString *errorMsg;
@property (nonatomic,copy)NSString *loadingMsg;

@property (nonatomic,copy) NSArray *citys;
@property (nonatomic,copy) NSArray *regions;
@property (nonatomic,copy) NSArray *districts;
@property (nonatomic,copy) NSArray *towns;
@end

@implementation HouseManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackNavWithOpaque:YES];
    self.title = @"房屋地址管理";
    [self.view addSubview:self.table];
    [self initData];
}
-(void)initData{
    [[RACObserve(self, errorMsg) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(NSString *errorMsg) {
        [NJDPopLoading showAutoHideWithMessage:errorMsg];
    }];
    
    [RACObserve(self, loadingMsg) subscribeNext:^(NSString *loadingMsg) {
        loadingMsg?[NJDPopLoading showMessageWithLoading:loadingMsg]:[NJDPopLoading hideHud];
    }];
    [self getLandlordAdd];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
        _table.tableFooterView = [UIView new];
        _table.tableHeaderView = [UIView new];
        [_table registerClass:[HouseCell class] forCellReuseIdentifier:@"houseCell"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}
-(void)getLandlordAdd{
    [NetworkingManager getLandLordAddressSuccess:^(NSArray * _Nullable arrayValue) {
        self.dataSource = arrayValue;
        [self.table reloadData];
    } failure:^(NSError * _Nullable error) {
        self.loadingMsg = nil;
        self.errorMsg = error.userInfo[NSLocalizedDescriptionKey];
        self.errorMsg = nil;
    }];
}
#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"houseCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = SAFE_STRING(dic[@"address"]);
    cell.textLabel.textColor = [UIColor sam_colorWithHex:@"333333"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSInteger index = -1;
    if (index == indexPath.row) {
        index = -1;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        index = indexPath.row;
    }
}
- (IBAction)addAddressHandle:(UIButton *)sender {
    
    AddAddressView *add = [AddAddressView new];
    [add showAt:self.view];
    @weakify(self);
    add.selectAddr = ^(NSString *regionId, NSString *address){
        [NetworkingManager landLordAddAddress:regionId
                                      address:address
                                      success:^(NSDictionary * _Nullable dictValue) {
                                           @strongify(self);
                                          self.errorMsg = [dictValue valueForKeyPath:@"accessResult.resultMsg"];
                                          self.errorMsg = nil;
                                          [self getLandlordAdd];
                                      } failure:^(NSError * _Nullable error) {
                                           @strongify(self);
                                          self.errorMsg = error.userInfo[NSLocalizedDescriptionKey];
                                          self.errorMsg = nil;
                                      }];
    };
}
- (IBAction)deleteAddressHandle:(UIButton *)sender {
    NSArray *paths = self.table.indexPathsForSelectedRows;
    if (paths.count == 0) {
        [NJDPopLoading showAutoHideWithMessage:@"请选择一个地址"];
        return;
    }
    NSInteger index = ((NSIndexPath *)[paths firstObject]).row;
    if (index < self.dataSource.count) {
        NSDictionary *dic = self.dataSource[index];
        [NetworkingManager landLordDeleteAddress:dic[@"id"]
                                         success:^(NSDictionary * _Nullable dictValue) {
                                             self.errorMsg = [dictValue valueForKeyPath:@"accessResult.resultMsg"];
                                             self.errorMsg = nil;
                                             [self getLandlordAdd];
                                         } failure:^(NSError * _Nullable error) {
                                             self.errorMsg = error.userInfo[NSLocalizedDescriptionKey];
                                             self.errorMsg = nil;

                                         }];
    }
}

@end
