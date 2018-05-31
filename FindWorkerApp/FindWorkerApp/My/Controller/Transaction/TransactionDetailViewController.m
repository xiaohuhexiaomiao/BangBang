//
//  TransactionDetailViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/9.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "CXZ.h"

@interface TransactionDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *listTbview;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation TransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTitleWithString:@"交易详情" withColor:[UIColor whiteColor]];
    [self.view addSubview:self.listTbview];
    self.listTbview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    [self.listTbview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 私有

-(void)reloadData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *pramDict = @{@"uid":uid,
                               @"order_num":self.tansactionID,
                               @"amount_type":@(self.type)};
    [[NetworkSingletion sharedManager]transactionDetail:pramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"xiang qing %@",dict);
        [self.listTbview.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        if ([dict[@"code"] integerValue]==0) {
            [self.dataArray addObjectsFromArray:dict[@"data"]];
        }
        [self.listTbview reloadData];
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.view];
        [self.listTbview.mj_header endRefreshing];
    }];
}

-(NSMutableAttributedString*)setAttributionWithTitle:(NSString*)title
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:@"¥"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.00] range:NSMakeRange(0, range.location)];
    return attributedStr;
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.attributedText = [self setAttributionWithTitle:[NSString stringWithFormat:@"向 %@ 支付 ¥%@",dict[@"name"],dict[@"amount"]]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

#pragma mark get/set 
-(UITableView*)listTbview
{
    if (!_listTbview) {
        _listTbview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listTbview.delegate = self;
        _listTbview.dataSource = self;
        _listTbview.tableFooterView = [UIView new];
    }
    return _listTbview;
}

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
