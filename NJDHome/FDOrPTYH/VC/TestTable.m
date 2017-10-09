//
//  TestTable.m
//  NJDHome
//
//  Created by JustinYang on 2017/10/9.
//  Copyright © 2017年 yuan yunlong. All rights reserved.
//

#import "TestTable.h"
@interface TestCell()
@property (nonatomic,strong) UILabel *textContantLabel;
@end
@implementation TestCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textContantLabel = [UILabel new];
        [self.contentView addSubview:self.textContantLabel];
        self.textContantLabel.numberOfLines = 0;
        [self.textContantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@16);
            make.bottom.right.equalTo(@-16);
            make.height.greaterThanOrEqualTo(@44);
        }];
        self.textContantLabel.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)setText:(NSString *)text{
    self.textContantLabel.text = SAFE_STRING(text);
}
@end

@interface TestTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@end

@implementation TestTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.table.estimatedRowHeight = 44;
    self.table.rowHeight = UITableViewAutomaticDimension;
    [self.table registerClass:[TestCell class] forCellReuseIdentifier:@"testCell"];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBackNavWithOpaque:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    NSString *str = @"";
    NSInteger count = 2+ arc4random()%5;
    for (int i = 0; i < count; i++) {
        str = [str stringByAppendingString:@"动态高度\n"];
    }
    cell.text = str;
    return cell;
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
