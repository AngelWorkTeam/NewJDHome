//
//  AddressSelectView.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "AddressSelectView.h"
#import "PickView1.h"
@interface AddressSelectView()
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *reginBtn;

@property (weak, nonatomic) IBOutlet UIButton *districtBtn;
@property (weak, nonatomic) IBOutlet UIButton *townBtn;

@property (nonatomic,copy) NSArray *citys;
@property (nonatomic,copy) NSArray *regions;
@property (nonatomic,copy) NSArray *districts;
@property (nonatomic,copy) NSArray *towns;
@end
@implementation AddressSelectView
{
    NSInteger _select[4];
}
-(instancetype)init{
    self = [[NSBundle mainBundle] loadNibNamed:@"Views" owner:self options:nil][0];
    memset(_select, 0, sizeof(_select));
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)startShowAddr{
    [NJDPopLoading showMessageWithLoading:@"正在加载地址"];
    [NetworkingManager getCitys:^(NSArray * _Nullable arrayValue) {
        self.citys = arrayValue;

    } failure:^(NSError * _Nullable error) {
        self.citys = nil;
        self.regions = nil;
        self.districts = nil;
        self.towns = nil;
    }];
}
-(void)getReginWithId:(NSString *)regionId{
    [NetworkingManager getRegions:regionId
                          success:^(NSArray * _Nullable arrayValue) {
                              self.regions = arrayValue;
                              
                          } failure:^(NSError * _Nullable error) {
                              self.regions = nil;
                              self.districts = nil;
                              self.towns = nil;
                          }];
}
-(void)getDistrictWithId:(NSString *)districtId{
    [NetworkingManager getGetDistrics:districtId
                          success:^(NSArray * _Nullable arrayValue) {
                              self.districts = arrayValue;
                          } failure:^(NSError * _Nullable error) {
                              self.districts = nil;
                              self.towns = nil;
                          }];
}
-(void)getTownsWithId:(NSString *)townIds{
    [NetworkingManager getGetTowns:townIds
                           success:^(NSArray * _Nullable arrayValue) {
                               self.towns = arrayValue;
                           } failure:^(NSError * _Nullable error) {
                               self.towns = nil;
                           }];
}
-(void)setCitys:(NSArray *)citys{
    _citys = citys;
    if (citys.count > 0) {
        NSDictionary *first = citys[0];
        [self.cityBtn
         setTitle:SAFE_STRING(first[@"shortName"]) forState:UIControlStateNormal];
        [self getReginWithId:SAFE_STRING(first[@"id"])];
    }else{
        [NJDPopLoading hideHud];
        [NJDPopLoading showAutoHideWithMessage:@"获取地址信息失败"];
        [self.cityBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.reginBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.districtBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.townBtn
         setTitle:@"" forState:UIControlStateNormal];
    }
}
-(void)setRegions:(NSArray *)regions{
    _regions = regions;
    if (regions.count > 0) {
        NSDictionary *first = regions[0];
        [self.reginBtn
         setTitle:SAFE_STRING(first[@"shortName"]) forState:UIControlStateNormal];
        [self getDistrictWithId:SAFE_STRING(first[@"id"])];
    }else{
        [NJDPopLoading hideHud];
        [NJDPopLoading showAutoHideWithMessage:@"获取地址信息失败"];
        [self.reginBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.districtBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.townBtn
         setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)setDistricts:(NSArray *)districts{
    _districts = districts;
    if (districts.count > 0) {
        NSDictionary *first = districts[0];
        [self.districtBtn
         setTitle:SAFE_STRING(first[@"shortName"]) forState:UIControlStateNormal];
        [self getTownsWithId:SAFE_STRING(first[@"id"])];
    }else{
        [NJDPopLoading hideHud];
        [NJDPopLoading showAutoHideWithMessage:@"获取地址信息失败"];
        [self.districtBtn
         setTitle:@"" forState:UIControlStateNormal];
        [self.townBtn
         setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)setTowns:(NSArray *)towns{
    _towns = towns;
    if (towns.count > 0) {
        [NJDPopLoading hideHud];
        NSDictionary *first = towns[0];
        [self.townBtn
         setTitle:SAFE_STRING(first[@"shortName"]) forState:UIControlStateNormal];
        [self callSelectBlock];
    }else{
        [NJDPopLoading hideHud];
        [NJDPopLoading showAutoHideWithMessage:@"获取地址信息失败"];
        [self.townBtn
         setTitle:@"" forState:UIControlStateNormal];
    }
}
-(void)callSelectBlock{
    if (self.selectAddress) {
        NSString *add = @"";
        NSDictionary *dic = self.citys[_select[0]];
        add = [add stringByAppendingString:SAFE_STRING(dic[@"shortName"])];
        dic = self.regions[_select[1]];
        add = [add stringByAppendingString:SAFE_STRING(dic[@"shortName"])];
        dic = self.districts[_select[2]];
        add = [add stringByAppendingString:SAFE_STRING(dic[@"shortName"])];
        dic = self.towns[_select[3]];
        add = [add stringByAppendingString:SAFE_STRING(dic[@"shortName"])];
        
        self.selectAddress(@[self.citys[_select[0]],
                             self.regions[_select[1]],
                             self.districts[_select[2]],
                             self.towns[_select[3]]],
                                               add);
    }
}
- (IBAction)popCityPick:(id)sender {
    if (self.citys.count > 1) {
        @weakify(self);
        [self popPickWithData:self.citys selectRow:^(NSInteger index) {
             @strongify(self);
            if (self->_select[0] != index) {
                self->_select[0] = index;
                NSDictionary *dic = self.citys[index];
                [self.cityBtn
                 setTitle:SAFE_STRING(dic[@"shortName"]) forState:UIControlStateNormal];
                [NJDPopLoading showMessageWithLoading:@"正在加载地址"];
                [self getReginWithId:SAFE_STRING(dic[@"id"])];
            }
            
        }];
    }
}
- (IBAction)popRegonPick:(id)sender {
    if (self.regions.count > 1) {
        @weakify(self);
        [self popPickWithData:self.regions selectRow:^(NSInteger index) {
            @strongify(self);
            if (self->_select[1] != index) {
                self->_select[1] = index;
                NSDictionary *dic = self.regions[index];
                [self.reginBtn
                 setTitle:SAFE_STRING(dic[@"shortName"]) forState:UIControlStateNormal];
                [NJDPopLoading showMessageWithLoading:@"正在加载地址"];
                [self getDistrictWithId:SAFE_STRING(dic[@"id"])];
            }
        }];
    }
}
- (IBAction)popDistricPick:(id)sender {
    if (self.districts.count > 1) {
        @weakify(self);
        [self popPickWithData:self.districts selectRow:^(NSInteger index) {
            @strongify(self);
            if (self->_select[2] != index) {
                self->_select[2] = index;
                NSDictionary *dic = self.districts[index];
                [self.districtBtn
                 setTitle:SAFE_STRING(dic[@"shortName"]) forState:UIControlStateNormal];
                [NJDPopLoading showMessageWithLoading:@"正在加载地址"];
                [self getTownsWithId:SAFE_STRING(dic[@"id"])];
            }
        }];
    }
}

- (IBAction)popTownPick:(id)sender {
    if (self.towns.count > 1) {
        @weakify(self);
        [self popPickWithData:self.towns selectRow:^(NSInteger index) {
            @strongify(self);
            if (self->_select[3] != index) {
                self->_select[3] = index;
                NSDictionary *dic = self.towns[index];
                [self.townBtn
                 setTitle:SAFE_STRING(dic[@"shortName"]) forState:UIControlStateNormal];
                [self callSelectBlock];
            }
        }];
    }
}


-(void)popPickWithData:(NSArray *)datas
             selectRow:(void (^)(NSInteger index))select{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:datas.count];
    for (int i = 0; i < datas.count; i++) {
        NSDictionary *dic = datas[i];
        [arr addObject:SAFE_STRING(dic[@"shortName"])];
    }
    
    PickView1 *pickView1 = [PickView1 new];
    pickView1.selectData = ^(NSString *element, NSInteger index){
        !select?:select(index);
    };
    pickView1.dataArr = arr;
    [[UIApplication sharedApplication].keyWindow addSubview:pickView1];
    pickView1.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, 218);
    
    [UIView animateWithDuration:0.4 animations:^{
        pickView1.frame = CGRectMake(0, kScreenHeight-218, kScreenWidth, 218);
    }];
}
@end
