//
//  HETSleepRefreshHeader.h
//  MJRefreshExample
//
//  Created by JustinYang on 2017/9/22.
//

#import "MJRefreshNormalHeader.h"

@interface NJDRefreshHeader : MJRefreshNormalHeader
/**
 *  下拉刷新activity颜色，在海豚睡眠中纯绿色背景下activity是白色
 *  在白色背景下activity的色值是5e5e5e，默认为白色， 请使用的开发
 *  根据自己页面的背景颜色来赋值
 */
@property (nonatomic,copy) UIColor *activityTintColor;
@end
