//
//  TransactionLogViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/1/7.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "TransactionLogViewController.h"
#import "CXZ.h"
#import "TransactionDetailViewController.h"
#import "TransactionCell.h"
#import "Transaction.h"
@interface TransactionLogViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat headHeight;
}
@property (nonatomic ,strong)UITableView *listTbview;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *incomeLabel;

@property (nonatomic, strong) UILabel *outLabel;

@property (nonatomic, strong) UIView *headView;

@end

@implementation TransactionLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitleWithString:@"交易记录" withColor:[UIColor whiteColor]];
    [self setupBackw];
    [self creatHeadView];
    [self getIoAmount];
    headHeight = 120;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listTbview];
    self.listTbview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self reloadLogData];
    }];
    [self.listTbview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 私有方法

-(void)reloadLogData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]transactionLogList:@{@"uid":uid} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"***jiaoyi*%@",dict);
        [self.dataArray removeAllObjects];
        [self.listTbview.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *dataArr = [dict objectForKey:@"data"];
            for (int i = 0; i < dataArr.count; i++) {
                Transaction *transaciton = [Transaction objectWithKeyValues:dataArr[i]];
                [self.dataArray addObject:transaciton];
            }
        }
        [self.listTbview reloadData];
        
    } OnError:^(NSString *error) {
        [self.listTbview.mj_header endRefreshing];
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];
    
}

-(void)getIoAmount
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[NetworkSingletion sharedManager]getIoAmount:@{@"uid":uid} onSucceed:^(NSDictionary *dict) {
        if ([dict[@"code"] integerValue]==0) {
            self.incomeLabel.text = [dict[@"data"] objectForKey:@"in_amount"];
            self.outLabel.text = [dict[@"data"] objectForKey:@"out_amount"];
        }else
        {
            [WFHudView showMsg:dict[@"message"] inView:self.navigationController.view];
        }
    } OnError:^(NSString *error) {
        [WFHudView showMsg:error inView:self.navigationController.view];
    }];
}

-(void)creatHeadView
{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headHeight)];
    CGFloat wh = 100;
    
    //总收入
    UIView *incomeView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, wh, wh)];
//    incomeView.center = CGPointMake(SCREEN_WIDTH/4, headHeight/2);
    incomeView.backgroundColor = TOP_GREEN;
    incomeView.layer.cornerRadius = wh/2;
    
    _incomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, wh, 30)];
    _incomeLabel.textColor = [UIColor whiteColor];
    _incomeLabel.font = [UIFont systemFontOfSize:18];
//    _incomeLabel.text = @"2000.00";
    _incomeLabel.textAlignment = NSTextAlignmentCenter;
    [incomeView addSubview:_incomeLabel];
    
    UILabel *inLabel = [[UILabel alloc]initWithFrame:CGRectMake(_incomeLabel.left, _incomeLabel.bottom, _incomeLabel.width, 20)];
    inLabel.font = [UIFont systemFontOfSize:14];
    inLabel.text = @"总收入";
    inLabel.textColor = [UIColor whiteColor];
    inLabel.textAlignment = NSTextAlignmentCenter;
    [incomeView addSubview:inLabel];
    [self.headView addSubview:incomeView];
    
    //线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, incomeView.top+25, 1, 50)];
    lineView.backgroundColor = TOP_GREEN;
    [self.headView addSubview:lineView];
    
    //总支出
    UIView *ioView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, incomeView.top, incomeView.width, incomeView.height)];
    ioView.backgroundColor = TOP_GREEN;
    ioView.layer.cornerRadius = wh/2;
    
    _outLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _incomeLabel.top, incomeView.width, 30)];
    _outLabel.textColor = [UIColor whiteColor];
    _outLabel.font = [UIFont systemFontOfSize:18];
//    _outLabel.text = @"2000.00";
    _outLabel.textAlignment = NSTextAlignmentCenter;
    [ioView addSubview:_outLabel];
    
    UILabel *ioLabe = [[UILabel alloc]initWithFrame:CGRectMake(_outLabel.left, _outLabel.bottom, _outLabel.width, 20)];
    ioLabe.font = inLabel.font;
    ioLabe.textColor = [UIColor whiteColor];
    ioLabe.text = @"总支出";
    ioLabe.textAlignment = NSTextAlignmentCenter;
    [ioView addSubview:ioLabe];
    [self.headView addSubview:ioView];
}

#pragma mark UITableView Delegate & Datasource

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
    TransactionCell *cell = (TransactionCell*)[tableView dequeueReusableCellWithIdentifier:@"transaction"];
    if (!cell) {
        cell = [[TransactionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transaction"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTransaction:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        TransactionDetailViewController * detailVC = [TransactionDetailViewController new];
        Transaction *tran = self.dataArray[indexPath.row];
        detailVC.tansactionID = tran.order_sn;
        detailVC.type = tran.amount_type;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark get/set 方法
-(UITableView*)listTbview
{
    if (!_listTbview) {
        _listTbview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _listTbview.delegate = self;
        _listTbview.dataSource = self;
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
