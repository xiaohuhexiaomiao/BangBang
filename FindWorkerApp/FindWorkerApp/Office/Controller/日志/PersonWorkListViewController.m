//
//  PersonWorkListViewController.m
//  FindWorkerApp
//
//  Created by cxz on 2017/11/24.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "PersonWorkListViewController.h"
#import "CXZ.h"

#import "DiaryTypeView.h"
#import "DiaryListCell.h"

#import "DiaryDetailViewController.h"
#import "WorkSignViewController.h"
#import "SignDetailViewController.h"
#import "PersonWorkerCountViewController.h"

#import "DiaryModel.h"
@interface PersonWorkListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic ,strong)  UITableView *diaryListTableview;

@property(nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation PersonWorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackw];
    if (self.type == 1) {
        [self setupTitleWithString:@"工作记录" withColor:[UIColor whiteColor]];
        [self setupNextWithImage:[UIImage imageNamed:@"calendar"]];
    }
    if (self.type == 2) {
        [self setupTitleWithString:@"外勤签到" withColor:[UIColor whiteColor]];
    }
    
    _diaryListTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _diaryListTableview.height = self.view.bounds.size.height-64;
    _diaryListTableview.delegate = self;
    _diaryListTableview.dataSource = self;
    _diaryListTableview.tableFooterView = [UIView new];
    _diaryListTableview.separatorColor = [UIColor clearColor];
    [self.view addSubview:_diaryListTableview];
    __weak typeof(self) weakself = self;
    _diaryListTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadFirstDate];
    }];
    _diaryListTableview.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself loadMoreDate];
    }];
    [_diaryListTableview.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark Publish Method

-(void)onNext
{
    PersonWorkerCountViewController *personVC = [[PersonWorkerCountViewController alloc]init];
    personVC.companyID = self.companyID;
    personVC.look_uid = self.look_uid;
    personVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVC animated:YES];
}


#pragma mark Date 相关

-(void)loadFirstDate
{
    [self.dataArray removeAllObjects];
    page = 1;
    [self loadDate];
}

-(void)loadMoreDate
{
    page ++;
    [self loadDate];
}

-(void)loadDate
{
    NSDictionary *paramDict = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                @"look_uid":self.look_uid,
                                @"p":@(page),
                                @"each":@(10),
                                @"type":@(self.type)};
    [[NetworkSingletion sharedManager]lookPersonDiaryList:paramDict onSucceed:^(NSDictionary *dict) {
        //        NSLog(@"plane %@",dict);
        [self.diaryListTableview.mj_header endRefreshing];
        [self.diaryListTableview.mj_footer endRefreshing];
        if ([dict[@"code"] integerValue]==0) {
            NSArray *diaryArray = [DiaryModel objectArrayWithKeyValuesArray:dict[@"data"]];
            NSArray *resultArray = [diaryArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                DiaryModel *model1 = (DiaryModel*)obj1;
                DiaryModel *model2 = (DiaryModel*)obj2;
                NSComparisonResult result = [model1.add_time compare:model2.add_time];
                return result == NSOrderedAscending;  // 降序
            }];
            [self.dataArray addObjectsFromArray:resultArray];
            [self.diaryListTableview reloadData];
        }
        
    } OnError:^(NSString *error) {
        [self.diaryListTableview.mj_header endRefreshing];
        [self.diaryListTableview.mj_footer endRefreshing];
    }];
}

#pragma mark UITableView Delegate  DataSource

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
    DiaryListCell *cell = (DiaryListCell *)[tableView dequeueReusableCellWithIdentifier:@"DiaryListCell"];
    if (!cell) {
        cell = [[DiaryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiaryListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > 0) {
        if (self.type == 1) {
           [cell setDiaryListCellWithModel:self.dataArray[indexPath.section]];
        }else{
           [cell setSignListCellWithModel:self.dataArray[indexPath.section]];
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryListCell* cell = (DiaryListCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        DiaryModel *model = self.dataArray[indexPath.section];
        if (model.form_type == 1) {
            DiaryDetailViewController *detailVC = [[DiaryDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if(model.form_type == 2){
            SignDetailViewController *detailVC = [[SignDetailViewController alloc]init];
//            detailVC.company_id = model.company_id;
            detailVC.publish_id = model.publish_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
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
