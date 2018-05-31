//
//  NearbyCompanyViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2018/5/14.
//  Copyright © 2018年 SimonWest. All rights reserved.
//

#import "NearbyCompanyViewController.h"
#import "CXZ.h"

#import "CompanyInfoCell.h"
#import "ComporationModel.h"

#import "SWFindJobsController.h"
#import "SWPublishController.h"

@interface NearbyCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}

@property(nonatomic ,strong)UITableView *companyTableview;

@property(nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation NearbyCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupBackw];
    [self setupNextWithString:@"发布工程" withColor:[UIColor whiteColor]];
    [self setupTitleWithString:@"附近公司 " withColor:[UIColor whiteColor]];
    _companyTableview  = [[UITableView alloc]init];
    _companyTableview.delegate = self;
    _companyTableview.dataSource = self;
    _companyTableview.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_companyTableview];
    [_companyTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(0);
    }];
    __weak typeof(self) weakself = self;
    _companyTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    _companyTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [_companyTableview.mj_header beginRefreshing];
}

-(void)onNext
{
    SWPublishController *publishVC = [[SWPublishController alloc]init];
    publishVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 数据相关
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
    NSDictionary *dict = @{@"p":@(page),@"each":@(15)};
    [[NetworkSingletion sharedManager]getAllCorporation:dict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"**all Company***%@",dict);
        [self.companyTableview.mj_header endRefreshing];
        [self.companyTableview.mj_footer endRefreshing];
        if ([dict[@"code"]integerValue]==0) {
            NSArray *array = dict[@"data"];
            if (array.count > 0) {
                NSArray *modelArray = [ComporationModel objectArrayWithKeyValuesArray:dict[@"data"]];
                [self.dataArray addObjectsFromArray:modelArray];
            }
            [self.companyTableview reloadData];
        }else{
            [MBProgressHUD showError:dict[@"message"] toView:self.view];
        }
    } OnError:^(NSString *error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}

#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *infoCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CompanyCell"];
    if (!infoCell) {
        infoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyCell"];
    }
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
       ComporationModel* model =   self.dataArray[indexPath.row];
       infoCell.textLabel.text = model.company_big_name;
    }
    infoCell.textLabel.font = [UIFont systemFontOfSize:13];
    return infoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CompanyInfoCell *cell = (CompanyInfoCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
         ComporationModel* model =   self.dataArray[indexPath.row];
        SWFindJobsController *jobVC = [[SWFindJobsController alloc]init];
        jobVC.companyid = model.company_big_id;
        jobVC.isCompany = YES;
        [self.navigationController pushViewController:jobVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark get set

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
