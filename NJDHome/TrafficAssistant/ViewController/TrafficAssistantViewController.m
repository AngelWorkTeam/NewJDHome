//
//  TrafficAssistantViewController.m
//  NJDHome
//
//  Created by yuan yunlong on 2017/9/30.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TrafficAssistantViewController.h"

@interface TrafficAssistantViewController ()

@end

@implementation TrafficAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"TrafficAssic";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
