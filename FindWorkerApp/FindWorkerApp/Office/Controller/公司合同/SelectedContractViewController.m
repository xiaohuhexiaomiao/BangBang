//
//  SelectedContractViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/22.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "SelectedContractViewController.h"
#import "CXZ.h"
#import "ContractCell.h"
#import "SWContactController.h"
#import "WebViewController.h"
@interface SelectedContractViewController ()<UITableViewDelegate,UITableViewDataSource,ContractCelleDelegate>
{
    NSInteger page;
}
@property(nonatomic, strong) UITableView *contractTabelview;

@property(nonatomic, strong) NSMutableArray *listArray;

@end

@implementation SelectedContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    
    _contractTabelview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _contractTabelview.delegate = self;
    _contractTabelview.dataSource = self;
    _contractTabelview.tableFooterView = [UIView new];
    [self.view addSubview:_contractTabelview];
    
    __weak typeof(self) weakself = self;
    _contractTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstData];
    }];
    _contractTabelview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_contractTabelview.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark Load Data

-(void)loadFirstData
{
    [self.listArray removeAllObjects];
    page = 1;
    [self loadData];
}
-(void)loadMoreData
{
    page++;
    [self loadData];
}

-(void)loadData
{
    if (self.isWorkerList) {//个人合同
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"type":@"0",
                                    @"p":@(page),
                                    @"each":@"10"};
        [[NetworkSingletion sharedManager]getPersonalContractList:paramDict onSucceed:^(NSDictionary *dict) {
//            NSLog(@"**personal*%@",dict);
            [self.contractTabelview.mj_header endRefreshing];
            [self.contractTabelview.mj_footer endRefreshing];
            if ([dict[@"code"] integerValue]==0) {
                [self.listArray addObjectsFromArray:dict[@"data"]];
                [self.contractTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
            
        } OnError:^(NSString *error) {
            [MBProgressHUD showError:error toView:self.view];
        }];
    }else{
        NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],
                                    @"type":@"0",
                                    @"p":@(page),
                                    @"each":@"10",
                                    @"company_id":self.companyID};
        [[NetworkSingletion sharedManager]getCompanyContractList:paramDict onSucceed:^(NSDictionary *dict) {
            [self.contractTabelview.mj_header endRefreshing];
            [self.contractTabelview.mj_footer endRefreshing];
//            NSLog(@"**contract*%@",dict);
            if ([dict[@"code"] integerValue]==0) {
                [self.listArray addObjectsFromArray:dict[@"data"]];
                [self.contractTabelview reloadData];
            }else{
                [MBProgressHUD showError:dict[@"message"] toView:self.view];
            }
        } OnError:^(NSString *error) {
             [MBProgressHUD showError:error toView:self.view];
        }];
    }
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractCell *cell = (ContractCell*)[tableView dequeueReusableCellWithIdentifier:@"ContractCell"];
    if (!cell) {
        cell = [[ContractCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContractCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (self.listArray.count > 0) {
        if (self.isWorkerList) {
            [cell showPersonalContract:self.listArray[indexPath.row]];
        }else{
            [cell showCompanyContract:self.listArray[indexPath.row]];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.listArray.count > 0) {
        NSDictionary *contractDict = self.listArray[indexPath.row];
        if (self.isWorkerList) {
            [self.delegate selectedContractWithDict:contractDict type:1];
        }else{
            [self.delegate selectedContractWithDict:contractDict type:2];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark Cell Delegate

-(void)clickTitleWithTag:(NSInteger)indext
{
        if (self.isWorkerList) {
            NSDictionary *contractDict = self.listArray[indext];
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
            NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/Find/contract_detail?skey=%@&skey_uid=%@&id=%@",API_HOST,token,uid,contractDict[@"contract_id"]];
            WebViewController *web = [WebViewController new];
            web.urlStr = urlStr;
            web.title = contractDict[@"title"];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;;
    
        }else{
            NSDictionary *contractDict = self.listArray[indext];
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_token"];
            NSString *uid =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSString *urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/find/contract_company_detail?skey=%@&skey_uid=%@&id=%@",API_HOST,token,uid,contractDict[@"contract_id"]];
            WebViewController *web = [WebViewController new];
            web.urlStr = urlStr;
            web.title = contractDict[@"title"];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
}


#pragma  mark get/set

-(NSMutableArray*)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
