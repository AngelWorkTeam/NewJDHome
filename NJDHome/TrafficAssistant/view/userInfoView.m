//
//  userInfoView.m
//  NJDHome
//
//  Created by 袁云龙 on 17/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "userInfoView.h"

@interface userInfoView ()

@property (nonatomic, strong) UILabel *usernamelabel;

@property (nonatomic, strong) UILabel *hujidizhiLabel;

@property (nonatomic, strong) UILabel *zanzhudizhilabel;

@property (nonatomic, strong) UILabel *fangjianbianhaolabel;

@property (nonatomic, strong) UILabel *lianxidianhualabel;

@property (nonatomic, strong) UILabel *shengfenzhenhao;

@property (nonatomic, strong) UILabel *wenhuachengdu;

@property (nonatomic, strong) UILabel *zongjiaoxinyang;

@property (nonatomic, strong) UILabel *zhenzhimianmao;

@property (nonatomic, strong) UILabel *zhiye;

@property (nonatomic, strong) UILabel *zhichengjishudengji;

@property (nonatomic, strong) UILabel *shenbaoshijian;

@property (nonatomic, strong) UILabel *zhuangtai;

@property (nonatomic, strong) UILabel *shengbaoleixing;


@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *titleArray1;
@property (nonatomic, strong) NSArray *titleArray2;
@end



@implementation userInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView ];
    }
    return self;
}

- (void)initContentView
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _titleArray = @[@"姓名:",@"户籍地址:",@"暂住地址:",@"房间编号:",@"联系电话:",@"身份证号:",@"文化程度:"];
    
    UIView *lastview ;
    for (int i  = 0 ; i < _titleArray.count ; i++) {
        UIView *cellView = [self createCellViewWithTitle:_titleArray[i]];
        [contentView addSubview:cellView];
        if (i == 0) {
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(contentView.mas_top);
                make.left.mas_equalTo(contentView.mas_left);
                make.right.mas_equalTo(contentView.mas_right);
                make.height.mas_equalTo(userinfocellHeight);
            }];
            
        }else{
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastview.mas_bottom);
                make.left.mas_equalTo(contentView.mas_left);
                make.right.mas_equalTo(contentView.mas_right);
                make.height.mas_equalTo(userinfocellHeight);
            }];
        }
        lastview = cellView;
    }

     _titleArray1 = @[@"宗教信仰:",@"政治面貌:",@"职业:",@"职称技术等级:"];
    for (int i  = 0 ; i < (_titleArray1.count/2) ; i++) {
        UIView *cellView = [self createCellViewWithTitle:_titleArray1[2*i]];
        [contentView addSubview:cellView];
        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastview.mas_bottom);
                make.left.mas_equalTo(contentView.mas_left);
                make.width.mas_equalTo(njdScreenWidth/2);
                make.height.mas_equalTo(userinfocellHeight);
        }];
        
        UIView *cellView1 = [self createCellViewWithTitle:_titleArray1[2*i+1]];
        [contentView addSubview:cellView1];
        [cellView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastview.mas_bottom);
            make.left.mas_equalTo(cellView.mas_right);
            make.width.mas_equalTo(njdScreenWidth/2);
            make.height.mas_equalTo(userinfocellHeight);
        }];
        
        lastview = cellView;
    }
    
    _titleArray2 = @[@"申报时间:",@"状态:",@"申报类型:"];
    for (int i  = 0 ; i < _titleArray2.count ; i++) {
        UIView *cellView = [self createCellViewWithTitle:_titleArray2[i]];
        [contentView addSubview:cellView];
 
        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastview.mas_bottom);
                make.left.mas_equalTo(contentView.mas_left);
                make.right.mas_equalTo(contentView.mas_right);
                make.height.mas_equalTo(userinfocellHeight);
        }];
        
        lastview = cellView;
    }
}

- (UIView *)createCellViewWithTitle:(NSString *)title
{
    UIView *cellview = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel *titleLabel = [self createTitleLableWithTitle:title];
    [cellview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellview.mas_top);
        make.left.mas_equalTo(cellview.mas_left);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(userinfocellHeight);
    }];
    
    UILabel *contentLabel = [self createContentLableWithTitle:@""];
    [cellview addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellview.mas_top);
        make.left.mas_equalTo(titleLabel.mas_right);
        make.right.mas_equalTo(cellview.mas_right);
        make.height.mas_equalTo(userinfocellHeight);
    }];

    if ([_titleArray containsObject:title]) {
        NSInteger index = [_titleArray indexOfObject:title];
        switch (index) {
                case 0:
                    _usernamelabel = contentLabel;
                    break;
                case 1:
                    _hujidizhiLabel = contentLabel;
                    break;
                case 2:
                    _zanzhudizhilabel = contentLabel;
                    break;
                case 3:
                    _fangjianbianhaolabel = contentLabel;
                    break;
                case 4:
                    _lianxidianhualabel = contentLabel;
                    break;
                case 5:
                    _shengfenzhenhao = contentLabel;
                    break;
                case 6:
                    _wenhuachengdu = contentLabel;
                    break;
                case 7:
                    _zongjiaoxinyang = contentLabel;
                    break;
            default:
                break;
        }
    }
    
    if ([_titleArray1 containsObject:title]) {
        NSInteger index = [_titleArray1 indexOfObject:title];
        switch (index) {
                case 0:
                _zongjiaoxinyang = contentLabel;
                break;
                case 1:
                _zhenzhimianmao = contentLabel;
                break;
                case 2:
                _zhiye= contentLabel;
                break;
                case 3:
            {
                _zhichengjishudengji = contentLabel;
                [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(80);
                }];
                break;}
            default:
                break;
        }

    }
    
    if ([_titleArray2 containsObject:title]) {
        NSInteger index = [_titleArray2 indexOfObject:title];
        switch (index) {
                case 0:
                _shenbaoshijian = contentLabel;
                break;
                case 1:
                _zhenzhimianmao = contentLabel;
                break;
                case 2:
                _zhuangtai = contentLabel;
                _zhuangtai.textColor = [UIColor redColor];
                break;
                case 3:
                _shengbaoleixing = contentLabel;
                _shengbaoleixing.textColor = [UIColor redColor];
                break;
            default:
                break;
        }
        
    }
    
    return cellview;
}


- (UILabel *)createTitleLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"666666"];
    titleLable.font = [UIFont systemFontOfSize:12];
    return titleLable;
}

- (UILabel *)createContentLableWithTitle:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLable.text = title;
    titleLable.textColor = [UIColor colorWithHexString:@"999999"];
    titleLable.font = [UIFont systemFontOfSize:12];
    return titleLable;
}


- (void)setModel:(TrafficAssistantTaskModel *)model
{
    _model = model;
    
    
    _shenbaoshijian.text = model.submitDateTime;
}


@end