//
//  UnRegisterCell.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/10.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "UnRegisterCell.h"
@interface UnRegisterCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNumLabel;

@end
@implementation UnRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setName:(NSString *)name{
    self.nameLabel.text = name;
}
-(void)setDetailAddr:(NSString *)detailAddr{
    self.detailAddrLabel.text = detailAddr;
}
-(void)setRoomNum:(NSString *)roomNum{
    self.roomNumLabel.text = roomNum;
}
- (IBAction)changeHandle:(id)sender {
    !self.changeBlock?:self.changeBlock();
}
- (IBAction)unRegisterHandle:(id)sender {
    !self.unRegisterBlock?:self.unRegisterBlock();
}

@end
