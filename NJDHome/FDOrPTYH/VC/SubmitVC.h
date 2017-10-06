//
//  SubmitVC.h
//  NJDHome
//
//  Created by JustinYang on 2017/10/3.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "NJDBaseController.h"
typedef NS_ENUM(NSInteger,SubmitType) {
    SubmitTypeOwn,
    SubmitTypeOther,
    SubmitTypeRenter
};
@interface SubmitVC : NJDBaseController
@property (nonatomic)  SubmitType type;
@end
