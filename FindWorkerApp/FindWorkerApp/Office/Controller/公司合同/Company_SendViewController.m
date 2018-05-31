//
//  Company_SendViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/16.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "Company_SendViewController.h"
#import "CXZ.h"
#import "CompanyContractCell.h"
#import "CompanyContractModel.h"
#import "CompanyReviewViewController.h"
#import "EditWebViewController.h"
@interface Company_SendViewController ()<UITableViewDelegate,UITableViewDataSource,CompanyContractDelegate>
{
    NSInteger page;
}
@property(nonatomic ,strong)UITableView *listTabelview;

@property(nonatomic , strong) NSMutableArray *listArray;

@end

@implementation Company_SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackw];
    [self setupTitleWithString:@"拟呈批合同" withColor:[UIColor whiteColor] ];
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
    [self.listArray removeAllObjects];
    [self loadData];
}

-(void)loadMoreData
{
    page ++;
    [self loadData];
}

-(void)loadData
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                };
    [[NetworkSingletion sharedManager]getContractDraftsList:@{@"p":@(page),@"each":@(15)} onSucceed:^(NSDictionary *dict) {
//        NSLog(@"company %@",dict);
        [self.listTabelview.mj_header endRefreshing];
        [self.listTabelview.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *dataArray = [CompanyContractModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.listArray addObjectsFromArray:dataArray];
            [self.listTabelview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        [self.listTabelview.mj_header endRefreshing];
        [self.listTabelview.mj_footer endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
//
}

#pragma mark cell delegate

-(void)clickSelected:(NSInteger)index
{
    CompanyContractModel *contractModel = self.listArray[index];
    WebViewController *web = [[WebViewController alloc]init];
    web.urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?id=%li",API_HOST,[contractModel.contract_draft_id integerValue]];
    web.titleString = contractModel.contract_name;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark UITableview Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyContractCell *cell =  (CompanyContractCell*)[tableView dequeueReusableCellWithIdentifier:@"CompanyContractCell"];
    if (!cell) {
        cell = [[CompanyContractCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyContractCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.tag = indexPath.row;
    if (self.isSelected) {
        cell.isSelected = YES;
    }
    if (self.listArray.count > 0) {
       [cell setSendContractCell:self.listArray[indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
        CompanyContractModel *contractModel = self.listArray[indexPath.row];
        if (self.isSelected) {
            [self.delegate selectedContract:contractModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{

            WebViewController *web = [[WebViewController alloc]init];
            web.urlStr = [NSString stringWithFormat:@"%@/index.php/Mobile/skey/look_draft?operation=2&view=2&id=%li",API_HOST,[contractModel.contract_draft_id integerValue]];
            if (![NSString isBlankString:contractModel.contract_name]) {
                web.titleString = contractModel.contract_name;
            }else{
                web.titleString = @"合同详情";
            }
            web.isShare = YES;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }

    }
    
}

#pragma mark GET / SET

-(NSMutableArray*)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}



@end
