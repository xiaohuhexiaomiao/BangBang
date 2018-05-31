//
//  AcceptHistoryViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/3/26.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "ReceiveAcceptHistoryController.h"
#import "CXZ.h"
#import "ApplyForAcceptModel.h"

@interface ReceiveAcceptHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong)UITableView *tabelView;

@property(nonatomic , strong)NSArray *titleArray;

@property(nonatomic , strong)NSArray *dataArray;

@end

@implementation ReceiveAcceptHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    [self setupNextWithString:@"合同" withColor:[UIColor whiteColor]];
    [self setupTitleWithString:@"验收申请" withColor:[UIColor whiteColor]];
    
    _titleArray = @[@"创建时间",@"报验单",@"结算单"];
    _tabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    _tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tabelView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onNext
{
    EditWebViewController *web = [[EditWebViewController alloc]init];
    web.titleString = @"合同";
    web.editType = 7;
    web.contractID = self.contract_id;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark load data

-(void)loadData
{
    [[NetworkSingletion sharedManager]applyForAcceptanceList:@{@"contract_id":@(self.contract_id)} onSucceed:^(NSDictionary *dict) {
        [self.tabelView.mj_header endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            self.dataArray = [ApplyForAcceptModel objectArrayWithKeyValuesArray:dict[@"data"]];
        }
        [self.tabelView reloadData];
        
    } OnError:^(NSString *error) {
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

    return self.titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NormalCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.textLabel.textColor = FORMLABELTITLECOLOR;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.detailTextLabel.textColor = FORMTITLECOLOR;
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (self.dataArray.count > 0) {
        ApplyForAcceptModel *model = self.dataArray[indexPath.section];
        NSArray *array = @[model.add_time,@"点击查看",@"点击查看"];
        cell.detailTextLabel.text = array[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        ApplyForAcceptModel *model = self.dataArray[indexPath.section];
        if (indexPath.row == 1) {
            EditWebViewController *web = [[EditWebViewController alloc]init];
            web.titleString = @"报验单";
            web.editType = 9;
            web.formid = [model.inspection_id integerValue];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
        if (indexPath.row == 2) {
            EditWebViewController *web = [[EditWebViewController alloc]init];
           
            web.titleString = @"结算单";
            web.editType = 10;
            web.formid = [model.settlement_id integerValue];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
