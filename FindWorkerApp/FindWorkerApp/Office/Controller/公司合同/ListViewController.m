//
//  Company_ReceiveViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ListViewController.h"
#import "CXZ.h"
#import "WebViewController.h"
#import "InspectionModel.h"
#import "SeelementModel.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic ,strong)UITableView *listTabelview;

@property(nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation ListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.list_type == 1) {
        [self setupBackw];
        [self setupTitleWithString:@"合同模板" withColor:[UIColor whiteColor]];
    }else if(self.list_type == 2){
        [self setupBackw];
        [self setupTitleWithString:@"报验单模板" withColor:[UIColor whiteColor]];
    }else if(self.list_type == 3){
        [self setupBackw];
        [self setupTitleWithString:@"结算单模板" withColor:[UIColor whiteColor]];
    }
    _listTabelview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - 49 - 49 - 10) style:UITableViewStylePlain];
    _listTabelview.delegate = self;
    _listTabelview.dataSource = self;
    _listTabelview.tableFooterView = [UIView new];
    [self.view addSubview:_listTabelview];
    
    __weak typeof(self) weakself = self;
    _listTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstData];
    }];
    _listTabelview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_listTabelview.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Load Data

-(void)loadFirstData
{
    page = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}

-(void)loadData
{
    if (self.list_type == 0) {
        [[NetworkSingletion sharedManager]getCompanyContractTypeList:@{@"type":@(1)} onSucceed:^(NSDictionary *dict) {
            //        NSLog(@"companyre %@",dict);
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                [self.dataArray addObjectsFromArray:dict[@"data"]];
                [self.listTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }else if (self.list_type == 1){
        [[NetworkSingletion sharedManager]getCompanyContractTypeList:@{@"type":@(2)} onSucceed:^(NSDictionary *dict) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                [self.dataArray addObjectsFromArray:dict[@"data"]];
                [self.listTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
        
    }else if (self.list_type == 2){
        
        [[NetworkSingletion sharedManager]getSingleInspectionList:nil onSucceed:^(NSDictionary *dict) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            
            NSLog(@"companyre %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [InspectionModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.dataArray addObjectsFromArray:array];
                [self.listTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else if (self.list_type == 3){
        
        [[NetworkSingletion sharedManager]getStatementsList:nil onSucceed:^(NSDictionary *dict) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            
            //             NSLog(@"companyre %@",dict);
            if ([dict[@"code"] integerValue]==0) {
                NSArray *array = [SeelementModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.dataArray addObjectsFromArray:array];
                [self.listTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
            [self.listTabelview.mj_header endRefreshing];
            [self.listTabelview.mj_footer endRefreshing];
            [MBProgressHUD showError:error toView:self.view];
        }];
    }
    
}



#pragma mark UITableview Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NormallCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormallCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    if (self.list_type == 0 || self.list_type == 1) {
        if (self.dataArray.count > 0) {
            cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"contract_name"];
        }
    }else if (self.list_type == 2){
        if (self.dataArray.count > 0) {
            InspectionModel *model = self.dataArray[indexPath.row];
            cell.textLabel.text = model.inspection_name;
            
        }
    }else if (self.list_type == 3){
        if (self.dataArray.count > 0) {
            SeelementModel *model = self.dataArray[indexPath.row];
            cell.textLabel.text = model.settlement_name;
            
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count >0) {
        
        if (self.list_type == 0) {
            NSDictionary *dict = self.dataArray[indexPath.row];
            EditWebViewController *web = [[EditWebViewController alloc]init];
            if (![NSString isBlankString:dict[@"contract_name"]]) {
                web.titleString = dict[@"contract_name"];
            }
            web.editType = 0;
            web.workID = self.workID;
            web.form_Type_ID = [dict[@"contract_type_id"] integerValue];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if (self.list_type == 1) {
            NSDictionary *dict = self.dataArray[indexPath.row];
            EditWebViewController *web = [[EditWebViewController alloc]init];
            if (![NSString isBlankString:dict[@"contract_name"]]) {
                web.titleString = dict[@"contract_name"];
            }
            web.editType = 1;
            web.projectID = self.project_id;
            web.workID = self.workID;
            web.form_Type_ID = [dict[@"contract_type_id"] integerValue];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if (self.list_type == 2) {
            InspectionModel *model = self.dataArray[indexPath.row];
            EditWebViewController *web = [[EditWebViewController alloc]init];
            if (![NSString isBlankString:model.inspection_name]) {
                web.titleString = model.inspection_name;
            }
            web.editType = 2;
            web.form_Type_ID = [model.inspection_type_id integerValue];
            web.contractID = self.contract_id;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if (self.list_type == 3) {
            SeelementModel *model = self.dataArray[indexPath.row];
            EditWebViewController *web = [[EditWebViewController alloc]init];
            if (![NSString isBlankString:model.inspection_name]) {
                web.titleString = model.inspection_name;
            }
            web.editType = 3;
            web.form_Type_ID = [model.settlement_type_id integerValue];
            web.contractID = self.contract_id;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    
    
}

#pragma mark GET / SET

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
