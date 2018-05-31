//
//  OnGoingViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/5/11.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "OnGoingViewController.h"
#import "CXZ.h"
#import "RecordsDetailListController.h"

#import "ConstructionRecordCell.h"

#import "RecordsListModel.h"
@interface OnGoingViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger page;
}

@property (nonatomic , strong) UITableView *listTabview;

@property (nonatomic , strong) NSMutableArray *listArray;

@end

@implementation OnGoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    _listTabview.height = self.view.frame.size.height-64-49;
    _listTabview.dataSource = self;
    _listTabview.delegate = self;
    _listTabview.tableFooterView = [UIView new];
    [self.view addSubview:_listTabview];
    
    __weak typeof(self) weakself = self;
    _listTabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [_listTabview.mj_header beginRefreshing];
    _listTabview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark Private Method

-(void)loadData
{
    [self.listArray removeAllObjects];
    page = 1;
    [self loadListData];
}

-(void)loadMoreData
{
    page++;
     [self loadListData];
}

-(void)loadListData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *paramDict = @{@"uid":uid,
                                @"type":@"1",
                                @"p":@(page),
                                @"each":@"10"};
    [[NetworkSingletion sharedManager]constuctionRecordsList:paramDict onSucceed:^(NSDictionary *dict) {
//        NSLog(@"shigong %@",dict);
        [self.listTabview.mj_header endRefreshing];
        [self.listTabview.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *array = [RecordsListModel objectArrayWithKeyValuesArray:dict[@"data"]];
            [self.listArray addObjectsFromArray:array];
            [self.listTabview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
        
    } OnError:^(NSString *error) {
        [self.listTabview.mj_header endRefreshing];
        [self.listTabview.mj_footer endRefreshing];
        [MBProgressHUD showError:error toView:self.view];
    }];
}


#pragma mark UITableviewDelegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"shigong %li",self.listArray.count);
    return self.listArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ConstructionRecordCell";
    ConstructionRecordCell *cell = (ConstructionRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ConstructionRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listArray.count > 0) {
         [cell setiConstuctionRecordCellWithModel:self.listArray[indexPath.row]];
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 55.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count > 0) {
        RecordsDetailListController *detailVC = [[RecordsDetailListController alloc]init];
        RecordsListModel *listModel = self.listArray[indexPath.row];
        detailVC.workerType = listModel.user_type;
        detailVC.productionName = listModel.contract_name;
        detailVC.constractid = listModel.contract_id;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.hidesBottomBarWhenPushed = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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

-(NSMutableArray*)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


@end
