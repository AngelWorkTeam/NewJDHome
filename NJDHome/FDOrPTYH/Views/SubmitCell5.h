//
//  SubmitCell5.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/4.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "SubmitCell.h"

@interface SubmitCell5 : SubmitCell
@property (nonatomic,copy) void (^tookPhoto)(UIImage *img);
@property (nonatomic,copy) void (^deleteAllImgs)(void); 
@property (nonatomic,weak) NSMutableArray *imgs;
@end
