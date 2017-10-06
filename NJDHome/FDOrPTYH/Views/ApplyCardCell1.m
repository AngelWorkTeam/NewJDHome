//
//  ApplyCardCell1.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/5.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "ApplyCardCell1.h"
#import "AddressSelectView.h"
@implementation ApplyCardCell1
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        AddressSelectView *select = [AddressSelectView new];
        [self.contentView addSubview:select];
        [select mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        @weakify(self);
        select.selectAddress = ^(NSArray *detailArr, NSString *address){
            @strongify(self);
            if (detailArr.count == 4) {
                NSDictionary *dic = detailArr[2];
                NSString *townId = dic[@"id"];
                dic = detailArr[3];
                NSString *regionId = dic[@"id"];
                !self.changeAddr?:self.changeAddr(townId,regionId,address);
            }
        };
        [select startShowAddr];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
