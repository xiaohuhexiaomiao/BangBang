//
//  ApplyPayHistoryViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/10.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ApplyPayHistoryViewController.h"
#import "CXZ.h"
#import "ShowPayHistoryModel.h"
#import "ShowPayHistoryCell.h"
@interface ApplyPayHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic , strong)UITableView *tabelView;

@property(nonatomic , strong)NSMutableArray *dataArray;

@end

@implementation ApplyPayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupTitleWithString:@"申请付款记录" withColor:[UIColor whiteColor]];
    
    _tabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    _tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_tabelView.mj_header beginRefreshing];
    _tabelView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark load data

-(void)loadNewData
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page++;
    [self loadData];
}


-(void)loadData
{
    NSDictionary *paramDict = @{@"contract_id":@(self.contract_id),
                                @"p":@(page),
                                @"each":@(15)};
        [[NetworkSingletion sharedManager]getApplyPayHistory:paramDict onSucceed:^(NSDictionary *dict) {
            [self.tabelView.mj_header endRefreshing];
            [self.tabelView.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [ShowPayHistoryModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.dataArray addObjectsFromArray:array];
            }
            [self.tabelView reloadData];
    
        } OnError:^(NSString *error) {
            [self.tabelView.mj_header endRefreshing];
            [self.tabelView.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
}


#pragma mark UITabelView Delegate & DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPayHistoryCell *cell = (ShowPayHistoryCell*)[tableView dequeueReusableCellWithIdentifier:@"ShowPayHistoryCell"];
    if (!cell) {
        cell = [[ShowPayHistoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ShowPayHistoryCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = self.type;
    if (self.dataArray.count > 0) {
       
        [cell setShowPayHistoryCellWithModel:self.dataArray[indexPath.section]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark get/set
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
